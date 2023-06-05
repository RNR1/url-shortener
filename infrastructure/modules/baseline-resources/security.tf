data "http" "myip" {
  url = "http://ipv4.icanhazip.com"
}

resource "aws_security_group" "ssh" {
  name        = "ssh-specific-ip"
  description = "Allow inbound SSH access to a specific IP address"
  vpc_id      = data.aws_vpc.default_vpc.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["${chomp(data.http.myip.response_body)}/32"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_security_group" "http" {
  name        = "http-in"
  description = "Allow all inbound HTTP access"
  vpc_id      = data.aws_vpc.default_vpc.id

  ingress {
    from_port   = 80
    protocol    = ""
    to_port     = 80
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_security_group" "https-in-http-out" {
  name        = "https-in-http-out"
  description = "Allow all inbound HTTPS and transmit HTTP"
  vpc_id      = data.aws_vpc.default_vpc.id

  ingress {
    from_port   = 443
    protocol    = ""
    to_port     = 443
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 80
    to_port     = 80
    protocol    = ""
    cidr_blocks = ["0.0.0.0/0"]
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_security_group" "postgres_inbound" {
  vpc_id      = data.aws_vpc.default_vpc.id
  name        = "rds-db-postgres"
  description = "Allow all inbound for Postgres"

  ingress {
    from_port   = 5432
    to_port     = 5432
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_secretsmanager_secret" "server" {
  name = "${var.app_slug}-secrets-${var.env_name}"
}
