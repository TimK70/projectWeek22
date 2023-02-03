#---networking/variables.tf---

variable "access_ip" {}

variable "private_cidrs" {
  type = list(any)
}

variable "public_cidrs" {
  type = list(any)
}

variable "vpc_cidr" {
  type = string
}

