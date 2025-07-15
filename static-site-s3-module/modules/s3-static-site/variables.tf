variable "bucket_name" {
  type = string
  description = "Globally unique S3 name"
}

variable "index_document" {
  type = string
  default = "index.html"
}

variable "error_document" {
  type = string
  default = "error.html"
}

variable "website_dir" {
  type = string
  description = "Path to local website HTML files"
}

variable "tags" {
  type = map(string)
  default = {
    "Environment" = "dev"
    "Owner" = "terraform"
  }
}