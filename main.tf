terraform {
  required_version = ">= 1.0.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

module "lambda_functions" {
  source = "./modules/lambda"

  role_name             = var.role_name
  lambda_runtime        = var.lambda_runtime
  lambda_memory_size    = var.lambda_memory_size
  lambda_timeout        = var.lambda_timeout
  lambda_ephemeral_size = var.lambda_ephemeral_size
  lambda_layers         = var.lambda_layers
  subnet_ids            = var.subnet_ids
  security_group_ids    = var.security_group_ids
  efs_access_point_id   = var.efs_access_point_id
  aws_region            = var.aws_region
  is_windows            = var.is_windows

  # Separate tags
  tag_environment = var.tag_environment
  tag_owner       = var.tag_owner
  tag_project     = var.tag_project
}
