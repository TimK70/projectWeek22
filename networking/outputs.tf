#---networking/outputs.tf---

output "private_sg" {
  value = aws_security_group.wk22_private_sg.id
}

output "private_subnet" {
  value = aws.subnet.wk22_private_subnet[*].id
}

output "public_sg" {
  value = aws_security_group.wk22_public_sg.id
}

output "public_subnet" {
  value = aws_subnet.wk22_public_subnet[*].id
}

output "web_sg" {
  value = aws_security_group.wk22_web_sg.id
}

output "vpc_id" {
  value = aws_vpc.wk22_vpc.id
}