output "private_isu_id" {
  value = aws_instance.private_isu.id
}

output "benchmark_id" {
  value = aws_instance.benchmark.id
}

output "public_ip" {
  value = aws_eip.private_isu.public_ip
}
