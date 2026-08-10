# tf-state-backend

Terraform IaC that creates the S3 bucket holding the remote `terraform.tfstate` for your project.
Uses Terraform **>= v1.10** for native S3 state locking (lockfile in the bucket, no DynamoDB).

*Intended to be run ONCE, separately from the Terraform config for your poject.*
*Everything in your project Terraform config should point its backend at the bucket this creates.*

```
Backend:    tf-state-backend --> S3 bucket + native lock (run ONCE, first)
```

## Repo Layout

| File           | Purpose                                                        |
| -------------- | -------------------------------------------------------------- |
| `main.tf`      | Root config ...the state S3 bucket and its versioning           |
| `variables.tf` | Root input variables (fill via `terraform.tfvars`)              |
| `outputs.tf`   | Exposes the bucket name for an other repo's backend config      |
| `terraform.tfvars.example` | Template for your values, copy to `terraform.tfvars` |
| `.gitignore`   | Keeps state, tfvars, and `.terraform/` out of git               |


## User Guide | Usage

Requires Terraform **>= 1.10** and AWS credentials configured (`aws configure` or env vars).

```bash
git clone git@github.com:geomux/tf-state-backend.git
cd tf-state-backend
cp terraform.tfvars.example terraform.tfvars    # fill in your values
terraform init                                  # local state, the bucket does not exist yet
terraform validate                              # checks config for errors (e.g. your terraform.tfvars values are acceptable format)
terraform plan                                  # creates dialogue for what apply will do
terraform apply                                 # creates the S3 bucket
```

This repo bootstraps its own backend, so it runs on a **local state file**. Every other repo/project then points at the bucket name from `terraform output`.

The bucket sets `prevent_destroy`, so `terraform destroy` errors on purpose. This safety catch stops you from deleting the bucket your other project's Terraform state file lives in.


## User Guide | *Moving the Local State File Into the Bucket*

Once the bucket is created, this repo's own local state can be added to it **for better long-term storage & security**. 
Add this backend block to `main.tf`, **see note at the top of main.tf** filling in the bucket name from `terraform output`:

```hcl
  backend "s3" {
    bucket       = "BUCKET_NAME_HERE"
    key          = "tf-state-backend/terraform.tfstate"
    region       = "var.aws_region"
    use_lockfile = true
  }
```

Then copy & re-initialize *see bash cmds below*.

[NOTE]
> Keep a local copy, just in case
```bash
cp terraform.tfstate terraform.tfstate.bak
terraform init -migrate-state
```

## Project Status

- [x] Create state backend repo
- [x] Root Terraform scaffolding (main / variables / outputs)
- [ ] Declare `project_name` and move resources to root level (see main.tf)
- [ ] `terraform apply` --> S3 bucket live
