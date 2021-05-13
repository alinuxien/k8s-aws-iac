# TerraForm Backend
terraform {
  backend "s3" {
    bucket = "[...]"
    key    = "[...]"
    region = "[...]"
  }
}
# AWS Provider
provider "aws" {
  region = "[...]"
}
# Import State "global" From Remote S3 Bucket
data "terraform_remote_state" "global" {
  backend = "s3"
  config = {
    region = "[...]"
    bucket = "[...]"
    key    = "[...]"
    ssh_pubkey = "[...]"
  }
}

