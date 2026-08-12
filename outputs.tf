# outputs.tf
# Root Terraform outputs config file for this IaC repo. Holds provisioned resource values after apply is run.

output "state_bucket_name" {
  description = "Name of the S3 bucket holding remote state file."
  value       = aws_s3_bucket.state.id
  sensitive   = false
}

output "state_bucket_region" {
  description = "Region the state bucket lives in."
  value      = aws_s3_bucket.state.region
  sensitive  = false
}
