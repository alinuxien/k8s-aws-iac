resource "aws_security_group" "alb" {
  name        = "alb"
  description = "Autoriser le traffic HTTP et HTTPS entrant"
  vpc_id      = aws_vpc.main.id

  tags = {
    Name = "alb"
  }
}

resource "aws_security_group_rule" "in_http" {
  type              = "ingress"
  from_port         = 80
  to_port           = 80
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.alb.id
}

resource "aws_security_group_rule" "in_https" {
  type              = "ingress"
  from_port         = 443
  to_port           = 443
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.alb.id
}

resource "aws_security_group_rule" "out_http" {
  type              = "egress"
  from_port         = 80
  to_port           = 80
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.alb.id
}

resource "aws_security_group_rule" "out_https" {
  type              = "egress"
  from_port         = 443
  to_port           = 443
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.alb.id
}

resource "aws_lb" "alb" {
  name                       = "alb"
  internal                   = false
  load_balancer_type         = "application"
  drop_invalid_header_fields = true
  security_groups            = [aws_security_group.alb.id]
  subnets                    = [aws_subnet.public-a.id, aws_subnet.public-b.id]

  tags = {
    name = "k8s-alb"
  }
}

resource "aws_lb_target_group" "tgs-wl" {
  name     = "tgs-wl"
  port     = 443
  protocol = "HTTPS"
  vpc_id   = aws_vpc.main.id
  stickiness {
    enabled         = true
    type            = "lb_cookie"
    cookie_duration = "86400"
  }
}

resource "aws_lb_target_group_attachment" "tgs-wl1" {
  target_group_arn = aws_lb_target_group.tgs-wl.arn
  target_id        = aws_instance.worker-0.id
  port             = 443
}

resource "aws_lb_target_group_attachment" "tgs-wl2" {
  target_group_arn = aws_lb_target_group.tgs-wl.arn
  target_id        = aws_instance.worker-1.id
  port             = 443
}

resource "aws_lb_listener" "alb-listener-secure-wl" {
  load_balancer_arn = aws_lb.alb.arn
  port              = 443
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-FS-2018-06"
  certificate_arn   = data.aws_acm_certificate.cert.arn

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.tgs-wl.arn
  }
}

resource "aws_lb_listener" "alb-listener-wl" {
  load_balancer_arn = aws_lb.alb.arn
  port              = 80
  protocol          = "HTTP"
  default_action {
    type = "redirect"
    redirect {
      protocol    = "HTTPS"
      port        = 443
      status_code = "HTTP_302"
    }
  }
}

