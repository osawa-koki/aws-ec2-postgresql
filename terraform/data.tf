
# PostgreSQLデータベースを作成
resource "aws_db_instance" "postgresql" {
  allocated_storage = 10
  engine            = "postgres"
  engine_version    = "11.12"
  instance_class    = "db.t2.micro"
  db_name           = var.db_database
  username          = var.db_username
  password          = var.db_password

  # VPCへの関連
  vpc_security_group_ids = [aws_security_group.security_group.id]
}
