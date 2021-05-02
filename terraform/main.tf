provider "aws" {
  region = ${TF_VAR_AWS_DEFAULT_REGION}
  access_key = ${TF_VAR_AWS_ACCESS_KEY_ID}
  secret_key = ${TF_VAR_AWS_SECRET_ACCESS_KEY}
}

data "aws_availability_zones" "available" {}

data "local_file" "local-pub-key" {
  filename = ${TF_VAR_AWS_SSH_PUBLIC_KEY_FILENAME}
}

resource "aws_key_pair" "aws_k8s" {
  key_name   = "aws_k8s_keypair"
  public_key = data.local_file.local-pub-key.content
}
