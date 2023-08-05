output "instance_id" {
  value = aws_instance.private_isu.id
}

output "public_ip" {
  value = aws_eip.private_isu.public_ip
}
