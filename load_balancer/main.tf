#--load_balancer/main.tf--

resource "aws_lb" "wk22_lb" {
  internal           = false
  load_balancer_type = "application"
  name               = "wk22-load-balancer"
  security_groups    = [var.web_sg]
  subnets            = tolist(var.public_subnet)

  depends_on = [
    var.asg_database
  ]
}

resource "aws_lb_target_group" "wk22_tg" {
  name     = "wk22-lb-tg-${substr(uuid(), 0, 3)}"
  protocol = "TCP"
  port     = 80
  vpc_id   = aws_vpc.wk22_vpc.id
  lifecycle {
    create_before_destroy = true
    ignore_changes        = [name]
  }
}

resource "aws_lb_listener" "wk22_lb_listener" {
  load_balancer_arn = aws_lb.wk22_lb.arn
  port              = var.listener_port
  protocol          = var.listener_protocol
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.wk22_tg.arn
  }
}