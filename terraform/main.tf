# TerraForm Backend : AWS S3 bucket
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

# AWS Provider for Terraform
provider "aws" {}

# Get AZs for the Region
data "aws_availability_zones" "region_azs" {}

# Get local pub key file
data "local_file" "local-pub-key" {
  filename = var.public_key_file
}

# Prepare EC2 Key Pair
resource "aws_key_pair" "ec2-keypair" {
  public_key = data.local_file.local-pub-key.content
}

data "aws_acm_certificate" "app-domain-cert" {
  domain = var.app-domain
}

data "aws_route53_zone" "app-domain-primary-zone" {
  name = var.app-domain
}

