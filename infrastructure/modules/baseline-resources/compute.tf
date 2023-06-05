resource "aws_instance" "server" {
  ami             = var.ami
  instance_type   = var.instance_type
  security_groups = [aws_security_group.ssh.id, aws_security_group.http.id]

  tags = {
    Name = "${var.app_slug}-${var.env_name}"
  }
}

resource "aws_eip" "server_elastic_ip" {
  instance = aws_instance.server.id
  domain   = "vpc"
}


resource "aws_instance" "worker" {
  ami             = var.ami
  instance_type   = var.instance_type
  security_groups = [aws_security_group.ssh.id]

  tags = {
    Name = "${var.app_slug}-worker-${var.env_name}"
  }
}

resource "aws_eip" "worker_elastic_ip" {
  instance = aws_instance.worker.id
  domain   = "vpc"
}
