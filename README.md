# terra-front-s3
Simple terraform script for provisioning an s3 bucket with a cloudfront distribution and associated roles and policies

This script will provision an s3 bucket and an associated cloudfront distribution for that bucket.

#### Setup
You will need the terraform exe in your path. You can download it [here](https://www.terraform.io/).

1. CD into this repository
2. Run `terraform init`
3. Run `terraform plan` to verify the current configuration
4. Run `terraform apply` to provision the infrastructure

You will need the access key and secret key for an IAM User who effectively has global access to all actions on your AWS account.

#### Rollback
Terraform does not roll back provisioned resources in the event of failure. If the script fails for whatever reason - run `terraform destroy` to remove any resources.