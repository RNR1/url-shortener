data "aws_route53_zone" "primary" {
  name = var.domain
}

resource "aws_acm_certificate" "app" {
  domain_name       = "s.${var.domain}"
  validation_method = "DNS"

  tags = {
    Environment = var.env_name
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_route53_record" "s" {
  zone_id = data.aws_route53_zone.primary.id
  name    = "s.${var.domain}"
  type    = "A"

  alias {
    name                   = aws_lb.server.dns_name
    zone_id                = aws_lb.server.zone_id
    evaluate_target_health = true
  }
}
