#---load_balancer/outputs.tf---

output "alb_dns" {
  value = aws_lb.wk22_lb.dns_name
}

output "alb_tg" {
  value = aws_lb_target_group.wk22_tg.arn
}

output "elb" {
  value = aws_lb.wk22_lb.id
}