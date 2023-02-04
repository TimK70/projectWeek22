#---networking/main.tf---

resource "random_integer" "random" {
  min = 1
  max = 50
}

resource "aws_vpc" "wk22_vpc" {
  cidr_block           = var.vpc_cidr
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Name = "wk22_vpc-${random_integer.random.id}"
  }
}

resource "aws_eip" "wk22_eip" {

}

resource "aws_internet_gateway" "wk22_igw" {
  vpc_id = aws_vpc.wk22_vpc.id

  tags = {
    Name = "wk22_igw"
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_nat_gateway" "wk22_nat_gateway" {
  allocation_id = aws_eip.wk22_eip.id
  subnet_id     = aws_subnet.wk22_public_subnet[1].id
}

resource "aws_route" "default_public_route" {
  route_table_id         = aws_route_table.wk22_public_rt.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.wk22_igw.id
}

resource "aws_route" "default_private_route" {
  route_table_id         = aws_route_table.wk22_private_rt.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.wk22_igw.id
}

resource "aws_default_route_table" "wk22_private_rt" {
  default_route_table_id = aws_vpc.wk22_vpc.default_route_table_id

  tags = {
    Name = "wk22_private"
  }
}

resource "aws_route_table" "wk22_public_rt" {
  vpc_id = aws_vpc.wk22_vpc.id

  tags = {
    Name = "wk22_public"
  }
}

resource "aws_route_table" "wk22_private_rt" {
  vpc_id = aws_vpc.wk22_vpc.id

  tags = {
    Name = "wk22_private"
  }
}

resource "aws_subnet" "wk22_public_subnet" {
  availability_zone       = ["eu-north-1a", "eu-north-1b", "eu-north-1c"][count.index]
  cidr_block              = var.public_cidrs[count.index]
  count                   = length(var.public_cidrs)
  map_public_ip_on_launch = true
  vpc_id                  = aws_vpc.wk22_vpc.id
}

resource "aws_route_table_association" "wk22_public_assoc" {
  count          = length(var.public_cidrs)
  subnet_id      = aws_subnet.wk22_public_subnet.*.id[count.index]
  route_table_id = aws_route_table.wk22_public_rt.id
}

resource "aws_subnet" "wk22_private_subnet" {
  availability_zone = ["eu-north-1a", "eu-north-1b", "eu-north-1c"][count.index]
  cidr_block        = var.private_cidrs[count.index]
  count             = length(var.private_cidrs)
  vpc_id            = aws_vpc.wk22_vpc.id
}

resource "aws_route_table_association" "wk22_private_assoc" {
  count          = length(var.private_cidrs)
  subnet_id      = aws_subnet.wk22_private_subnet.*.id[count.index]
  route_table_id = aws_route_table.wk22_private_rt.id
}

resource "aws_security_group" "wk22_public_sg" {
  name        = "wk22_bastion_sg"
  description = "Allow inbound SSH traffic"
  vpc_id      = aws_vpc.wk22_vpc.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [var.access_ip]

  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "wk22_private_sg" {
  name        = "wk22_database_sg"
  description = "Allow inbound SSH traffic from Bastion"
  vpc_id      = aws_vpc.wk22_vpc.id

  ingress {
    from_port       = 22
    to_port         = 22
    protocol        = "tcp"
    security_groups = [aws_security_group.wk22_public_sg.id]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port       = 80
    to_port         = 80
    protocol        = "tcp"
    security_groups = [aws_security_group.wk22_web_sg.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "wk22_web_sg" {
  name        = "wk22_web_sg"
  description = "Allow all inbound HTTP traffic"
  vpc_id      = aws_vpc.wk22_vpc.id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}