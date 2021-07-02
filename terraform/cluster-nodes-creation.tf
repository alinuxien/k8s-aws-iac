resource "aws_security_group" "k8s-sg" {
  name        = "k8s-sg"
  description = "Groupe de Securite des Nodes K8S"
  vpc_id      = aws_vpc.main.id

  tags = {
    Name = "k8s-sg"
  }
}

resource "aws_security_group_rule" "in-all-for-internal" {
  type              = "ingress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = [aws_vpc.main.cidr_block]
  security_group_id = aws_security_group.k8s-sg.id
}

resource "aws_security_group_rule" "in-ssh-for-external" {
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.k8s-sg.id
}

resource "aws_security_group_rule" "in-https-for-external" {
  type              = "ingress"
  from_port         = 443
  to_port           = 443
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.k8s-sg.id
}

resource "aws_security_group_rule" "in-https-other-port-for-external" {
  type              = "ingress"
  from_port         = 6443
  to_port           = 6443
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.k8s-sg.id
}

resource "aws_security_group_rule" "in-icmp-for-external" {
  type              = "ingress"
  from_port         = 8
  to_port           = 0
  protocol          = "icmp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.k8s-sg.id
}

resource "aws_security_group_rule" "out-all" {
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.k8s-sg.id
}

resource "aws_instance" "controller-0" {
  ami                    = var.k8s-nodes-ami
  instance_type          = var.k8s-controller-nodes-instance-type
  subnet_id              = aws_subnet.private-a.id
  vpc_security_group_ids = [aws_security_group.k8s-sg.id]
  key_name               = aws_key_pair.ec2-keypair.id
  source_dest_check      = false
  tags = {
    Name = "controller-0"
  }
}

resource "aws_instance" "controller-1" {
  ami                    = var.k8s-nodes-ami
  instance_type          = var.k8s-controller-nodes-instance-type
  subnet_id              = aws_subnet.private-b.id
  vpc_security_group_ids = [aws_security_group.k8s-sg.id]
  key_name               = aws_key_pair.ec2-keypair.id
  source_dest_check      = false
  tags = {
    Name = "controller-1"
  }
}

resource "aws_instance" "worker-0" {
  ami                    = var.k8s-nodes-ami
  instance_type          = var.k8s-worker-nodes-instance-type
  subnet_id              = aws_subnet.private-a.id
  vpc_security_group_ids = [aws_security_group.k8s-sg.id]
  key_name               = aws_key_pair.ec2-keypair.id
  source_dest_check      = false
  tags = {
    Name = "worker-0"
  }
}

resource "aws_instance" "worker-1" {
  ami                    = var.k8s-nodes-ami
  instance_type          = var.k8s-worker-nodes-instance-type
  subnet_id              = aws_subnet.private-b.id
  vpc_security_group_ids = [aws_security_group.k8s-sg.id]
  key_name               = aws_key_pair.ec2-keypair.id
  source_dest_check      = false
  tags = {
    Name = "worker-1"
  }
}

