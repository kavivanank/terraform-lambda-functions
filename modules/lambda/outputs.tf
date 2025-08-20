output "lambda_functions" {
  description = "Map of Lambda function names to ARNs"
  value       = { for k, f in aws_lambda_function.this : k => f.arn }
}

output "efs_access_point_arn" {
  description = "EFS Access Point ARN"
  value       = "arn:aws:elasticfilesystem:${var.aws_region}:${data.aws_caller_identity.current.account_id}:access-point/${var.efs_access_point_id}"
}

