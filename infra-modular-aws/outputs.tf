output "public_ip" {
  value = module.ec2.public_ip
}

output "instance_id" {
  value = module.ec2.instance_id
}

output "vpc_id" {
  value = module.vpc.vpc_id
}