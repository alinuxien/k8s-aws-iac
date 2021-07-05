resource "aws_security_group" "alb-security-group" {
  name        = "alb-security-group"
  description = "Autoriser le traffic HTTP et HTTPS entrant"
  vpc_id      = aws_vpc.cluster-vpc.id

  tags = {
    Project = var.project_name
    Name    = "alb-security-group"
  }
}

resource "aws_security_group_rule" "in_http" {
  type              = "ingress"
  from_port         = 80
  to_port           = 80
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.alb-security-group.id
}

resource "aws_security_group_rule" "in_https" {
  type              = "ingress"
  from_port         = 443
  to_port           = 443
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.alb-security-group.id
}

resource "aws_security_group_rule" "out_http" {
  type              = "egress"
  from_port         = 80
  to_port           = 80
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.alb-security-group.id
}

resource "aws_security_group_rule" "out_https" {
  type              = "egress"
  from_port         = 443
  to_port           = 443
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.alb-security-group.id
}

resource "aws_security_group_rule" "in_app" {
  type              = "ingress"
  from_port         = 30000
  to_port           = 32767
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.alb-security-group.id
}

resource "aws_security_group_rule" "out_app" {
  type              = "egress"
  from_port         = 30000
  to_port           = 32767
  protocol          = "tcp"
  cidr_blocks       = ["10.0.0.0/16"]
  security_group_id = aws_security_group.alb-security-group.id
}


resource "aws_lb" "alb" {
  name                       = "alb"
  internal                   = false
  load_balancer_type         = "application"
  drop_invalid_header_fields = true
  security_groups            = [aws_security_group.alb-security-group.id]
  subnets                    = [aws_subnet.public-a.id, aws_subnet.public-b.id]

  tags = {
    Project = var.project_name
    Name    = "alb"
  }
}

resource "aws_lb_target_group" "target-group-secure-app" {
  name     = "target-group-secure-app"
  port     = 443
  protocol = "HTTPS"
  vpc_id   = aws_vpc.cluster-vpc.id
  stickiness {
    enabled         = true
    type            = "lb_cookie"
    cookie_duration = "86400"
  }
}

resource "aws_lb_target_group_attachment" "target-group-secure-app1" {
  target_group_arn = aws_lb_target_group.target-group-secure-app.arn
  target_id        = aws_instance.worker-0.id
  port             = 443
}

resource "aws_lb_target_group_attachment" "target-group-secure-app2" {
  target_group_arn = aws_lb_target_group.target-group-secure-app.arn
  target_id        = aws_instance.worker-1.id
  port             = 443
}

resource "aws_lb_listener" "alb-listener-secure-app" {
  load_balancer_arn = aws_lb.alb.arn
  port              = 443
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-FS-2018-06"
  certificate_arn   = data.aws_acm_certificate.app-domain-cert.arn

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.target-group-secure-app.arn
  }
}

resource "aws_lb_target_group" "target-group-app" {
  name     = "target-group-app"
  port     = 30000
  protocol = "HTTP"
  vpc_id   = aws_vpc.cluster-vpc.id
}

resource "aws_lb_target_group_attachment" "target-group-app1" {
  target_group_arn = aws_lb_target_group.target-group-app.arn
  target_id        = aws_instance.worker-0.id
  port             = 30000
}

resource "aws_lb_target_group_attachment" "target-group-app2" {
  target_group_arn = aws_lb_target_group.target-group-app.arn
  target_id        = aws_instance.worker-1.id
  port             = 30000
}


resource "aws_lb_listener" "alb-listener-app" {
  load_balancer_arn = aws_lb.alb.arn
  port              = 30000
  protocol          = "HTTP"
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.target-group-app.arn
  }
}

