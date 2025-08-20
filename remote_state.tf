terraform {
  backend "s3" {
    bucket = "lambda-bckt-1208"
    key    = "terraform.tfstate"
    region = "us-west-2"
  }
}