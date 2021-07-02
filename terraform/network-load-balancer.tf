resource "aws_lb" "nlb" {
  name                       = "nlb"
  internal                   = false
  load_balancer_type         = "network"
  drop_invalid_header_fields = false
  subnets                    = [aws_subnet.public-a.id, aws_subnet.public-b.id]

  tags = {
    name = var.project_name
  }
}

resource "aws_lb_target_group" "target-group-secure" {
  name     = "target-group-secure"
  port     = 6443
  protocol = "TCP"
  vpc_id   = aws_vpc.cluster-vpc.id
  stickiness {
    enabled         = true
    type            = "source_ip"
    cookie_duration = "86400"
  }
}

resource "aws_lb_target_group_attachment" "target-group-secure-0" {
  target_group_arn = aws_lb_target_group.target-group-secure.arn
  target_id        = aws_instance.controller-0.id
  port             = 6443
}

resource "aws_lb_target_group_attachment" "target-group-secure-1" {
  target_group_arn = aws_lb_target_group.target-group-secure.arn
  target_id        = aws_instance.controller-1.id
  port             = 6443
}

resource "aws_lb_listener" "nlb-listener-secure" {
  load_balancer_arn = aws_lb.nlb.arn
  port              = 6443
  protocol          = "TCP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.target-group-secure.arn
  }
}

