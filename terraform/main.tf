# TerraForm Backend
terraform {
  backend "s3" {
    bucket = "[...]"
    key    = "[...]"
    region = "[...]"
  }

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "= 3.40.0"
    }
  }

  required_version = "= 0.15.3"
}

# AWS Provider
provider "aws" {}

# Get AZs
data "aws_availability_zones" "available" {}

# Get local pub key file
data "local_file" "local-pub-key" {
  filename = var.public_key_file
}

# Prepare EC2 Key Pair
resource "aws_key_pair" "keypair" {
  public_key = data.local_file.local-pub-key.content
}

