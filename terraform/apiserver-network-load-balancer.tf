resource "aws_lb" "lb" {
  name                       = "kubernetes"
  internal                   = false
  load_balancer_type         = "network"
  drop_invalid_header_fields = false
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
  target_id        = aws_instance.controller-0.id
  port             = 6443
}

resource "aws_lb_target_group_attachment" "tgs2" {
  target_group_arn = aws_lb_target_group.tgs.arn
  target_id        = aws_instance.controller-1.id
  port             = 6443
}

resource "aws_lb_listener" "lb-listener-secure" {
  load_balancer_arn = aws_lb.lb.arn
  port              = 6443
  protocol          = "TCP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.tgs.arn
  }
}

