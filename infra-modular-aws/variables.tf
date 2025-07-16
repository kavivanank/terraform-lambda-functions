variable "aws_region" {
  type = string
}

variable "vpc_name" {
  type = string
}

variable "vpc_cidr" {
  type = string
}

variable "public_subnets" {
  type = list(string)
}

variable "availability_zone" {
  type = list(string)
}

variable "ec2_name" {
  type = string
}

variable "ami_id" {
  type = string
}

variable "instance_type" {
  type = string
}

variable "ec2_user_data" {
  type = string
  default = ""
}

variable "ec2_user_data_path" {
  type = string
  default = "user_data.sh"
}

variable "user_data_template_path" {
  type = string
  default = "user_data.sh.tpl"
}

variable "enable_ssm" {
  type = bool
}

variable "root_volume_size" {
  type = number
}

variable "additional_ebs_volumes" {
  type = list(object({
    device_name = string
    volume_size = number
    volume_type = string
  }))
}