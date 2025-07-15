terraform {
  backend "s3" {
    bucket = "devops-tf-state-bucket-72910"
    key = "static-site/dev/terraform.tfstate"
    region = "us-east-1"
    dynamodb_table = "terraform-locks"
    encrypt = true
  }
}