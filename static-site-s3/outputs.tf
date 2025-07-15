output "website_url" {
  description = "The URL of the static website hosted on S3"
  value       = aws_s3_bucket_website_configuration.static_site_config.website_endpoint
}