provider "aws" {
  region = "us-east-1"
}

module "static_site" {
  source = "../../modules/s3-static-site"
  bucket_name = var.bucket_name
  website_dir = "${path.module}/../../website"
  tags = var.tags
}