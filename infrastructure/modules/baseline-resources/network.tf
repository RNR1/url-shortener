data "aws_vpc" "default_vpc" {
  default = true
}


resource "aws_lb" "server" {
  name               = "${var.app_slug}-lb-${var.env_name}"
  load_balancer_type = "application"
  security_groups    = [aws_security_group.https-in-http-out.id]


  tags = {
    Environment = var.env_name
  }
}

resource "aws_lb_target_group" "server" {
  name     = "${var.app_slug}-lb-tg-${var.env_name}"
  port     = 80
  protocol = "HTTP"
  vpc_id   = data.aws_vpc.default_vpc.id

  health_check {
    enabled  = true
    interval = 300
    path     = "/health"
    protocol = "HTTP"
  }
}

resource "aws_lb_listener" "server" {
  load_balancer_arn = aws_lb.server.arn
  port              = "443"
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-2016-08"
  certificate_arn   = aws_acm_certificate.app.arn

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.server.arn
  }
}
