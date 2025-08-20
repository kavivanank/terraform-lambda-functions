# Separate tag variables for Lambda

variable "tag_environment" {
  description = "Environment for Lambda functions (e.g., dev, prod)"
  type        = string
}

variable "tag_owner" {
  description = "Owner of the Lambda functions"
  type        = string
}

variable "tag_project" {
  description = "Project name for the Lambda functions"
  type        = string
}

# Runtime and configuration variables

variable "lambda_runtime" {
  description = "Runtime for Lambda functions"
  type        = string
}

variable "lambda_memory_size" {
  description = "Memory size for all Lambda functions (MB)"
  type        = number
}

variable "lambda_timeout" {
  description = "Timeout for all Lambda functions (seconds)"
  type        = number
}

variable "lambda_ephemeral_size" {
  description = "Ephemeral storage size for all Lambda functions (MB)"
  type        = number
}

variable "lambda_layers" {
  description = "List of Lambda layer ARNs"
  type        = list(string)
  default     = []
}

variable "is_windows" {
  description = "Set to true if running Terraform on Windows"
  type        = bool
  default     = false
}

variable "role_name" {
  description = "Existing IAM Role name for Lambda execution"
  type        = string
}

variable "subnet_ids" {
  description = "Subnet IDs for Lambda VPC config"
  type        = list(string)
}

variable "security_group_ids" {
  description = "Security Group IDs for Lambda VPC config"
  type        = list(string)
}

variable "efs_access_point_id" {
  description = "EFS Access Point ID"
  type        = string
}

variable "aws_region" {
  description = "AWS Region"
  type        = string
}