resource "aws_security_group" "lb" {
  name        = "lb"
  description = "Autoriser le traffic HTTP et HTTPS entrant"
  vpc_id      = aws_vpc.main.id

  tags = {
    Name = "lb"
  }
}

resource "aws_security_group_rule" "in_http" {
  type              = "ingress"
  from_port         = 80
  to_port           = 80
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.lb.id
}

resource "aws_security_group_rule" "in_https" {
  type              = "ingress"
  from_port         = 443
  to_port           = 443
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.lb.id
}

resource "aws_security_group_rule" "out_http" {
  type              = "egress"
  from_port         = 80
  to_port           = 80
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.lb.id
}

resource "aws_security_group_rule" "out_https" {
  type              = "egress"
  from_port         = 443
  to_port           = 443
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.lb.id
}

resource "aws_lb" "lb" {
  name                       = "kubernetes"
  internal                   = false
  load_balancer_type         = "network"
  drop_invalid_header_fields = false
  security_groups            = [aws_security_group.lb.id]
  subnets                    = [aws_subnet.public-a.id, aws_subnet.public-b.id]

  tags = {
    name = "kubernetes"
  }
}

resource "aws_lb_target_group" "tgs" {
  name     = "kubernetes"
  port     = 6443
  protocol = "TCP"
  vpc_id   = aws_vpc.main.id
  stickiness {
    enabled         = true
    type            = "source_ip"
    cookie_duration = "86400"
  }
}

resource "aws_lb_target_group_attachment" "tgs1" {
  target_group_arn = aws_lb_target_group.tgs.arn
  target_id        = aws_instance.k8s-node-master-a.id
  port             = 443
}

resource "aws_lb_listener" "lb-listener-secure" {
  load_balancer_arn = aws_lb.lb.arn
  port              = 443
  protocol          = "TCP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.tgs.arn
  }
}

