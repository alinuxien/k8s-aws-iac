resource "aws_security_group" "k8s-sg" {
  name        = "k8s-sg"
  description = "Groupe de Securite des Nodes K8S"
  vpc_id      = aws_vpc.main.id

  tags = {
    Name = "k8s-sg"
  }
}

resource "aws_security_group_rule" "in-ssh" {
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  cidr_blocks       = [aws_vpc.main.cidr_block]
  security_group_id = aws_security_group.k8s-sg.id
}

resource "aws_security_group_rule" "in-http" {
  type              = "ingress"
  from_port         = 80
  to_port           = 80
  protocol          = "tcp"
  cidr_blocks       = [aws_vpc.main.cidr_block]
  security_group_id = aws_security_group.k8s-sg.id
}

resource "aws_security_group_rule" "in-https" {
  type              = "ingress"
  from_port         = 443
  to_port           = 443
  protocol          = "tcp"
  cidr_blocks       = [aws_vpc.main.cidr_block]
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

resource "aws_instance" "k8s-node-master-a" {
  ami                    = var.ami-k8s-nodes
  instance_type          = var.instance-type-k8s-node-master
  subnet_id              = aws_subnet.private-a.id
  vpc_security_group_ids = [aws_security_group.k8s-sg.id]
  key_name               = aws_key_pair.keypair.id
  tags = {
    Name = "node-master-a"
  }
}

