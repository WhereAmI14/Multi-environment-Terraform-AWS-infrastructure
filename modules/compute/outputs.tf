output "instance_id" {
  value = aws_instance.app.id
}

output "public_ip" {
  value = aws_instance.app.public_ip
}

output "web_security_group_id" {
  value = aws_security_group.web.id
}
