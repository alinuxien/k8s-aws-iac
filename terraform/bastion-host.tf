resource "aws_security_group" "bastion-security-group" {
  name        = "bastion-security-group"
  vpc_id      = aws_vpc.main.id

  ingress {
    description = "Allows ssh in from anywhere"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    description = "Allows ssh out to any host in the VPC"
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
  ami                         = var.bastion-ami
  instance_type               = var.bastion-instance-type
  subnet_id                   = aws_subnet.public-a.id
  associate_public_ip_address = true
  key_name                    = aws_key_pair.ec2-keypair.id
  vpc_security_group_ids      = [aws_security_group.bastion-security-group.id]
  tags = {
    Name = "bastion"
  }
}

