
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
    cidr_blocks = ["${var.allowed_ip_address}/32"]
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

# VPCエンドポイントを作成
resource "aws_vpc_endpoint" "vpc_endpoint" {
  vpc_id             = aws_vpc.vpc.id
  service_name       = "com.amazonaws.us-east-1.rds"
  security_group_ids = [aws_security_group.security_group.id]
}