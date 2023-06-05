variable "network_interface_id" {
  type    = string
  default = "eni-0bcfc230888453f48"
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
