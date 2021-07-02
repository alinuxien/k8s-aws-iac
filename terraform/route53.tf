resource "aws_route53_record" "A-record" {
  zone_id = data.aws_route53_zone.app-domain-primary-zone.zone_id
  name    = var.app-domain
  type    = "A"

  alias {
    name                   = aws_lb.alb.dns_name
    zone_id                = aws_lb.alb.zone_id
    evaluate_target_health = false
  }
}
