
provider "aws" {
  region = "ap-northeast-1"
}

# VPCを作成
resource "aws_vpc" "vpc" {
  cidr_block = "10.0.0.0/16"
}

# サブネットを作成
resource "aws_subnet" "subnet" {
  vpc_id     = aws_vpc.vpc.id
  cidr_block = "10.0.1.0/24"
}

# VPCに関する設定
resource "aws_security_group" "security_group" {
  name_prefix = "${var.project_name}-security-group"
  vpc_id      = aws_vpc.vpc.id

  # EC2インバウンド設定
  ingress {
    description = "Allow SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["${var.allowed_ip_address}/0"]
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # EC2アウトバウンド設定
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_key_pair" "ssh_key" {
  key_name   = "${var.project_name}-key"
  public_key = file(var.ssh_public_key_path)
}

# EC2を作成
resource "aws_instance" "vm" {
  ami             = "ami-be4a24d9"
  instance_type   = "t2.micro"
  security_groups = [aws_security_group.security_group.id]
  key_name        = aws_key_pair.ssh_key.key_name

  # VPCへの関連
  vpc_security_group_ids = [aws_security_group.security_group.id]
  subnet_id              = aws_subnet.subnet.id
}

# PostgreSQLデータベースを作成
resource "aws_db_instance" "postgresql" {
  allocated_storage = 10
  engine            = "postgres"
  engine_version    = "11.4"
  instance_class    = "db.t2.micro"
  name              = "example-postgresql"
  username          = var.db_username
  password          = var.db_password

  # VPCへの関連
  vpc_security_group_ids = [aws_security_group.example_security_group.id]
  // subnet_group_name      = aws_db_subnet_group.example_db_subnet_group.name

  # PostgreSQLインバウンド設定
  ingress {
    from_port       = 5432
    to_port         = 5432
    protocol        = "tcp"
    security_groups = [aws_security_group.security_group.id]
  }

  # PostgreSQLアウトバウンド設定
  egress {
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    security_groups = [aws_security_group.security_group.id]
  }

  #PostgreSQLインバウンド設定（allowed_ip_addressとVPC内からのアクセスを許可）
  ingress {
    from_port       = 5432
    to_port         = 5432
    protocol        = "tcp"
    cidr_blocks     = [aws_vpc.vpc.cidr_block]
    security_groups = [aws_security_group.security_group.id]
  }
}

# VPCエンドポイントを作成
resource "aws_vpc_endpoint" "example_vpc_endpoint" {
  vpc_id             = aws_vpc.vpc.id
  service_name       = "com.amazonaws.us-east-1.rds"
  security_group_ids = [aws_security_group.security_group.id]
}

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
