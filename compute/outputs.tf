#---compute/outputs.tf---

output "asg_database" {
  value = aws_autoscaling_group.wk22_database
}