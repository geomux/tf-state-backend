# variables.tf
# Root Terraform variables config file for this IaC repo. Formats root main.tf script.


variable "project_name" {
  description = "Name of your project ...will prefix your bucket name."
  type        = string
  default     = "my-project"
}

variable "aws_region" {
  description = "Name your desired region ...will be where the bucket lives."
  type        = string
  default     = "us-east-1"
}
