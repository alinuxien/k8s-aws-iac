provider "aws" {
  region = "eu-west-3"
}

provider "aws" {
  region = "us-east-1"
  alias  = "use1"
}

data "aws_availability_zones" "available" {}

data "local_file" "local-pub-key" {
  filename = var.public_key_file
}

data "aws_acm_certificate" "cloudfront" {
  provider = aws.use1
  domain   = var.domain
}

data "aws_acm_certificate" "cert" {
  domain = var.domain
}

data "aws_route53_zone" "primary" {
  name = var.domain
}

resource "aws_key_pair" "keypair" {
  key_name   = "keypair"
  public_key = data.local_file.local-pub-key.content
}
