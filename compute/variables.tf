#---compute/variables.tf---

variable "alb_tg" {}
variable "elb" {}
variable "key_name" {}
variable "public_sg" {}
variable "public_subnet" {}
variable "private_sg" {}
variable "private_subnet" {}

variable "bastion_instance_type" {
    type = string
    default = "t2.micro"
}

variable "database_instance_type" {
    type = string
    default = "t2.micro"
}