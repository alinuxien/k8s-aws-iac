resource "aws_security_group" "allow-ssh" {
  name        = "bastion"
  description = "Security Group du Bastion SSH"
  vpc_id      = aws_vpc.main.id

  ingress {
    description = "autorise le SSH entrant depuis partout"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    description = "autorise le SSH sortant vers le VPC"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [aws_vpc.main.cidr_block]
  }

  tags = {
    Name = "bastion"
  }
}

resource "aws_instance" "bastion" {
  #  user_data                   = data.terraform_remote_state.global.user_data
  ami                         = var.ami-bastion
  instance_type               = var.instance-type-bastion
  subnet_id                   = aws_subnet.public-a.id
  associate_public_ip_address = true
  key_name                    = data.terraform_remote_state.global.ssh_pubkey
  vpc_security_group_ids      = [aws_security_group.allow-ssh.id]
  tags = {
    Name = "bastion-a"
  }
  # ignore user_data updates, as this will require a new resource!
  #  lifecycle {
  #    ignore_changes = [
  #      "user_data",
  #    ]
  #  }
}

