variable "aws_region" {
  default = "us-east-1"
}

variable "vpc_cidr_block" {
  description = "CIDR block for VPC"
  type        = string
  default     = "10.0.0.0/16"
}

variable "subnet_count" {
  description = "Number of subnets"
  type        = map(number)
  default = {
    "public"  = 1,
    "private" = 2,
  }
}

variable "public_subnet_cidr_blocks" {
  description = "Available CIDR blocks for public subnets"
  type        = list(string)
  default = [
    "10.0.1.0/24",
    "10.0.2.0/24",
    "10.0.3.0/24",
    "10.0.4.0/24"
  ]
}

variable "private_subnet_cidr_blocks" {
  description = "Available CIDR blocks for private subnets"
  type        = list(string)
  default = [
    "10.0.101.0/24",
    "10.0.102.0/24",
    "10.0.103.0/24",
    "10.0.104.0/24",
  ]
}

variable "db_engine" {
  description = "The database engine and version"
  type        = map(string)
  default = {
    engine         = "postgres"
    engine_version = "14"
  }
}

variable "db_instance_class" {
  description = "The database instance"
  type        = string
  default     = "db.t2.micro"
}

variable "db_allocated_storage" {
  description = "storage in gigabytes"
  type        = number
  default     = 10
}


variable "instance_settings" {
  description = "Database configuration"
  type        = map(any)
  default = {
    count         = 1
    instance_type = "t2.micro"
  }
}

variable "ami" {
  type    = string
  default = "ami-053b0d53c279acc90"
}

variable "instance_type" {
  type    = string
  default = "t2.micro"
}

variable "app_slug" {
  type = string
}

variable "app_name" {
  type = string
}

variable "env_name" {
  type = string
}


variable "domain" {
  type = string
}
