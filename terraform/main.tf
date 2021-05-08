provider "aws" {
  region = "eu-west-3"
}

data "aws_availability_zones" "available" {}

