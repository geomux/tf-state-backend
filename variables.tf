# variables.tf
# Root Terraform variables config file for this IaC repo. Formats root main.tf script.


variable "project_name" {
  description = "PROJECT_NAME_HERE" # update accordingly
  type = string
}

variable "aws_region" {
  description = "us-east-1" # update accordingly
  type        = string
}
