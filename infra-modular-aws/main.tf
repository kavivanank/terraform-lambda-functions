provider "aws" {
  region = var.aws_region
}

module "vpc" {
  source            = "./modules/vpc"
  name              = var.vpc_name
  cidr_block        = var.vpc_cidr
  public_subnets    = var.public_subnets
  availability_zone = var.availability_zone
}

locals {
  rendered_user_data = templatefile(var.ec2_user_data_path, {app_name = var.ec2_name})
}

module "ec2" {
  source            = "./modules/ec2"
  name              = var.ec2_name
  ami               = var.ami_id
  instance_type     = var.instance_type
  subnet_id         = module.vpc.public_subnet_id[0]
  vpc_id            = module.vpc.vpc_id
  user_data         = local.rendered_user_data
  enable_ssm        = var.enable_ssm
  root_volume_size  = var.root_volume_size
  additional_ebs_volumes = var.additional_ebs_volumes
}