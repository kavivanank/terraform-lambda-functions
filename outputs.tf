output "lambda_functions" {
  description = "Map of deployed Lambda functions and their ARNs"
  value       = module.lambda_functions.lambda_functions
}

output "efs_access_point_arn" {
  description = "EFS Access Point ARN"
  value       = module.lambda_functions.efs_access_point_arn
}
