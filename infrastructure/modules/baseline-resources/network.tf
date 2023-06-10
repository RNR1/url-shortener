resource "aws_vpc" "main" {
  cidr_block           = var.vpc_cidr_block
  enable_dns_hostnames = true

  tags = {
    Name = "${var.app_slug}-vpc-${var.env_name}"
  }
}

resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "${var.app_slug}-igw-${var.env_name}"
  }
}

resource "aws_subnet" "public" {
  count             = var.subnet_count.public
  vpc_id            = aws_vpc.main.id
  cidr_block        = var.public_subnet_cidr_blocks[count.index]
  availability_zone = data.aws_availability_zones.available.names[count.index]

  tags = {
    Name = "${var.app_slug}-public-subnet-${count.index}-${var.env_name}"
  }
}

resource "aws_subnet" "private" {
  count      = var.subnet_count.private
  vpc_id     = aws_vpc.main.id
  cidr_block = var.private_subnet_cidr_blocks[count.index]
}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.main.id
  }
}

resource "aws_route_table_association" "public" {
  count = var.subnet_count.public

  route_table_id = aws_route_table.public.id

  subnet_id = aws_subnet.public[count.index].id
}

resource "aws_route_table" "private" {
  vpc_id = aws_vpc.main.id
}

resource "aws_route_table_association" "private" {
  count          = var.subnet_count.private
  route_table_id = aws_route_table.private.id
  subnet_id      = aws_subnet.private[count.index].id
}


resource "aws_lb" "server" {
  name               = "${var.app_slug}-server-lb-${var.env_name}"
  load_balancer_type = "application"
  security_groups    = [aws_security_group.lb.id]


  tags = {
    Environment = var.env_name
  }
}

resource "aws_lb_target_group" "server" {
  name     = "${var.app_slug}-server-lb-tg-${var.env_name}"
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_vpc.main.id

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
