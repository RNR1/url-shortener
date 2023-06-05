resource "random_string" "db_password" {
  length  = 32
  upper   = true
  numeric = true
  special = false
}

resource "aws_db_instance" "db" {
  db_name                = "${var.app_slug}-db-${var.env_name}"
  instance_class         = "db.t2.micro"
  allocated_storage      = 5
  engine                 = "postgres"
  engine_version         = "14"
  skip_final_snapshot    = true
  publicly_accessible    = false
  vpc_security_group_ids = [aws_security_group.postgres_inbound.id]
  username               = var.app_slug
  password               = random_string.db_password.result
}

