#---compute/main.tf---

resource "aws_launch_template" "wk22_bastion" {
  image_id               = data.aws_ami.linux.id
  instance_type          = var.bastion_instance_type
  name_prefix            = "wk22_bastion"
  vpc_security_group_ids = [var.public_sg]

  tags = {
    Name = "wk22_bastion"
  }
}

resource "aws_autoscaling_group" "wk22_bastion" {
  desired_capacity     = 1
  min_size             = 1
  max_size             = 1
  name                 = "wk22_bastion"
  vpc_zone_identifier = tolist(var.public_subnet)


  launch_template {
    id      = aws_launch_template.wk22_bastion.id
    version = "$latest"
  }
}


resource "aws_launch_template" "wk22_database" {
  image_id               = data.aws_ami.linux.id
  instance_type          = var.database_instance_type
  name_prefix            = "wk22_database"
  user_data              = filebase64("httpd_install.sh")
  vpc_security_group_ids = [var.private_sg]
}

resource "aws_autoscaling_group" "wk22_database" {
  desired_capacity = 2
  name             = "wk22_database"
  min_size         = 2
  max_size         = 3

  launch_template {
    id      = aws_launch_template.wk22_database.id
    version = "$latest"
  }
}

resource "aws_autoscaling_attachment" "wk22_database" {
  autoscaling_group_name = aws_autoscaling_group.wk22_database.id
  alb_target_group_arn = var.alb_tg
}

data "aws_ami" "linux" {
  most_recent = true

  filter {
    name = "name"
    values = ["amzn2-ami-hvm-*-x86_64-gp2"]
  }

  owners = ["amazon"]
}

