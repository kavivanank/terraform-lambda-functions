variable "name" {
  type = string
}

variable "ami" {
  type = string
}

variable "instance_type" {
  type = string
}

variable "subnet_id" {
  type = string
}

variable "vpc_id" {
  type = string
}

variable "user_data" {
  type = string
  default = ""
}

variable "enable_ssm" {
  type = bool
  default = true
}

variable "root_volume_size" {
  type = number
  default = 8
}

variable "additional_ebs_volumes" {
  description = "List of additional EBS volumes to attach"
  type = list(object({
    device_name = string
    volume_size = number
    volume_type = string
  }))
  default = []
}