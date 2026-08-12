# main.tf
# Root Terraform main config file for this IaC repo. Uses root variables.tf to format this script.

terraform {

  ### -----------------------------------------------
  ### --- ADD BACKEND BLOCK (from README.md) HERE ---
  ### -----------------------------------------------

  required_version = ">= 1.10"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "6.58.0"
    }
  }
}


### -----------------------------------
### --- CLOUD CONNECTION & IDENTITY ---
### -----------------------------------

provider "aws" {
  region = var.aws_region
}

data "aws_caller_identity" "current" {}


### ------------------------
### --- MAIN CLOUD INFRA ---
### ------------------------

resource "aws_s3_bucket" "state" {
  bucket = "${var.project_name}-tfstate-${data.aws_caller_identity.current.account_id}"

  tags = {
    Name = "tf-state-backend Bucket"
  }

  ### !!! TEMPORARILY DISABLED FOR TEARDOWN — RESTORE BEFORE THE NEXT APPLY !!!
  # lifecycle {
  #   prevent_destroy = true # CRUCIAL for "terraform destroy" erroring msg'ing Vs. destroying S3 bucket with state file in it
  # }
}

### ------------------------------
### --- AUXILIARY CLOUD INFRA ----
### ------------------------------

resource "aws_s3_bucket_versioning" "state" {
  bucket = aws_s3_bucket.state.id

  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "state" {
  bucket = "${var.project_name}-tfstate-${data.aws_caller_identity.current.account_id}"

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

resource "aws_s3_bucket_public_access_block" "state" {
  bucket = "${var.project_name}-tfstate-${data.aws_caller_identity.current.account_id}"

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}



