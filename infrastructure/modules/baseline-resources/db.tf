resource "random_string" "db_password" {
  length  = 32
  upper   = true
  numeric = true
  special = false
}

resource "aws_db_subnet_group" "db" {
  name        = "${var.app_slug}-db-subnet-group-${var.env_name}"
  description = "DB subnet group for ${var.app_name} (${var.env_name})"

  subnet_ids = [for subnet in aws_subnet.private : subnet.id]
}

resource "aws_db_instance" "db" {
  db_name                = "${var.app_slug}-db-${var.env_name}"
  instance_class         = "db.t2.micro"
  allocated_storage      = 10
  engine                 = "postgres"
  engine_version         = "14"
  skip_final_snapshot    = true
  publicly_accessible    = false
  vpc_security_group_ids = [aws_security_group.db.id]
  username               = var.app_slug
  password               = random_string.db_password.result
}

