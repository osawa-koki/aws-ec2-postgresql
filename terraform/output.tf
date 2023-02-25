
# 出力設定
output "public_ip" {
  value = aws_instance.vm.public_ip
}

output "database_endpoint" {
  value = aws_db_instance.postgresql.endpoint
}

output "database_port" {
  value = aws_db_instance.postgresql.port
}
