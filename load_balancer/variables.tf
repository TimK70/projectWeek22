#---load_balancer/variables.tf---

variable "asg_database" {}
variable "public_subnet" {}
variable "vpc_id" {}
variable "web_sg" {}

variable "listener_port" {
  default = 80
}

variable "listener_protocol" {
  default = "HTTP"
}

variable "tg_port" {
  default = 8001
}

variable "tg_protocol" {
  default = "HTTP"
}