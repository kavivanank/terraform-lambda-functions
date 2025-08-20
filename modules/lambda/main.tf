# Identify AWS account
data "aws_caller_identity" "current" {}

# Get IAM Role details
data "aws_iam_role" "lambda_role" {
  name = var.role_name
}

# Discover all lambda function directories under /lambda
locals {
  # Path to the lambda folder relative to this module
  lambda_base_path = "${path.module}/../../lambda"

  # Find all subfolders under lambda/ that contain at least one .py file
  lambda_dirs = distinct([
    for f in fileset(local.lambda_base_path, "*/*.py") :
    split("/", f)[0]
  ])

  # Create mapping of function name -> filename & handler
  lambda_functions = {
    for dir in local.lambda_dirs : dir => {
      filename = "${dir}.py"
      handler  = "${dir}.lambda_handler"
    }
  }

  # Merge all tag variables into one map
  merged_tags = {
    Environment = var.tag_environment
    Owner       = var.tag_owner
    Project     = var.tag_project
  }
}


# Copy certificates into each Lambda source folder
resource "null_resource" "copy_certs" {
  for_each = local.lambda_functions

  provisioner "local-exec" {
    interpreter = var.is_windows ? ["powershell", "-Command"] : ["bash", "-c"]

    command = var.is_windows ? "New-Item -ItemType Directory -Force -Path '${local.lambda_base_path}\\${each.key}'; Copy-Item -Path '${path.module}\\..\\..\\certs\\*' -Destination '${local.lambda_base_path}\\${each.key}' -Recurse -Force" : "mkdir -p ${local.lambda_base_path}/${each.key} && cp -r ${path.module}/../../certs/* ${local.lambda_base_path}/${each.key}/"
  }
}

# Package Lambda functions
data "archive_file" "lambda_zip" {
  for_each    = local.lambda_functions
  type        = "zip"
  source_dir  = "${local.lambda_base_path}/${each.key}"
  output_path = "${path.module}/build/${each.key}.zip"

  depends_on = [null_resource.copy_certs]
}

# Deploy Lambda functions
resource "aws_lambda_function" "this" {
  for_each      = local.lambda_functions

  # Append environment tag to name
  function_name = "${each.key}-${var.tag_environment}"

  handler       = each.value.handler
  runtime       = var.lambda_runtime
  role          = data.aws_iam_role.lambda_role.arn
  filename      = data.archive_file.lambda_zip[each.key].output_path

  memory_size = var.lambda_memory_size
  timeout     = var.lambda_timeout

  ephemeral_storage {
    size = var.lambda_ephemeral_size
  }

  vpc_config {
    subnet_ids         = var.subnet_ids
    security_group_ids = var.security_group_ids
  }

  file_system_config {
    arn              = "arn:aws:elasticfilesystem:${var.aws_region}:${data.aws_caller_identity.current.account_id}:access-point/${var.efs_access_point_id}"
    local_mount_path = "/mnt/efs"
  }

  layers = var.lambda_layers
  tags   = local.merged_tags
}

# Cleanup certificates after Lambda deployment
resource "null_resource" "cleanup_certs" {
  for_each = local.lambda_functions

  provisioner "local-exec" {
    interpreter = var.is_windows ? ["powershell", "-Command"] : ["bash", "-c"]

    # Delete .pem files from each lambda source folder
    command = var.is_windows ? "Remove-Item -Path '${local.lambda_base_path}\\${each.key}\\*.pem' -Force" : "rm -f ${local.lambda_base_path}/${each.key}/*.pem"
  }

  depends_on = [aws_lambda_function.this]
}