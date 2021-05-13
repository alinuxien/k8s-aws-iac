data "aws_availability_zones" "available" {}

data "local_file" "local-pub-key" {
  filename = var.public_key_file
}

resource "aws_key_pair" "keypair" {
  key_name   = "keypair"
  public_key = data.local_file.local-pub-key.content
}

