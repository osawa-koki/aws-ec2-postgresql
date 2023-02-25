
# PostgreSQLデータベースを作成
resource "aws_db_instance" "postgresql" {
  allocated_storage   = 10
  engine              = "postgres"
  engine_version      = "11.12"
  instance_class      = "db.t2.micro"
  db_name             = var.db_name
  username            = var.db_username
  password            = var.db_password
  publicly_accessible = true
  skip_final_snapshot = true

  # VPCへの関連
  vpc_security_group_ids = [aws_security_group.security_group_postgresql.id]
  db_subnet_group_name = aws_db_subnet_group.subnet_group.name

  tags = {
    Name = "${var.project_name}-postgresql"
  }
}
