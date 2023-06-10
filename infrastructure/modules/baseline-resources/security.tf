data "http" "myip" {
  url = "http://ipv4.icanhazip.com"
}

resource "aws_security_group" "server" {
  name        = "${var.app_slug}-server-sg-${var.env_name}"
  description = "Allow inbound SSH and HTTP"
  vpc_id      = aws_vpc.main.id

  ingress {
    description = "Allow all traffic through HTTP"
    from_port   = 80
    protocol    = "tcp"
    to_port     = 80
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "Allow SSH from my ip"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["${chomp(data.http.myip.response_body)}/32"]
  }

  egress {
    description = "Allow all outbound traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_security_group" "worker" {
  name        = "${var.app_slug}-worker-sg-${var.env_name}"
  description = "Allow inbound SSH access to a specific IP address"
  vpc_id      = aws_vpc.main.id

  ingress {
    description = "Allow SSH from my ip"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["${chomp(data.http.myip.response_body)}/32"]
  }

  egress {
    description = "Allow all outbound traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  lifecycle {
    create_before_destroy = true
  }
}


resource "aws_security_group" "lb" {
  name        = "${var.app_slug}-lb-sg-${var.env_name}"
  description = "Allow all inbound HTTPS and outbound HTTP"
  vpc_id      = aws_vpc.main.id

  ingress {
    description = "Allow all inbound HTTPS"
    from_port   = 443
    protocol    = "SSL"
    to_port     = 443
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    description = "Allow all outbound HTTP"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_security_group" "db" {
  vpc_id      = aws_vpc.main.id
  name        = "rds-db-postgres"
  description = "Allow all inbound for Postgres"

  ingress {
    from_port       = 5432
    to_port         = 5432
    protocol        = "tcp"
    cidr_blocks     = ["0.0.0.0/0"]
    security_groups = [aws_security_group.server.id]
  }
}

resource "aws_secretsmanager_secret" "server" {
  name = "${var.app_slug}-secrets-${var.env_name}"
}
