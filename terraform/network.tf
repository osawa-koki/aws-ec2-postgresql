
# VPCを作成
resource "aws_vpc" "vpc" {
  cidr_block = "10.0.0.0/16"
  tags = {
    Name = "${var.project_name}-vpc"
  }
}

resource "aws_db_subnet_group" "subnet_group" {
  name       = "${var.project_name}-subnet-group"
  subnet_ids = [aws_subnet.subnet_a.id, aws_subnet.subnet_b.id]
  tags = {
    Name = "${var.project_name}-db-subnet-group"
  }
}

# サブネットを作成
resource "aws_subnet" "subnet" {
  vpc_id     = aws_vpc.vpc.id
  cidr_block = "10.0.0.0/24"
  tags = {
    Name = "${var.project_name}-main-subnet"
  }
}

resource "aws_subnet" "subnet_a" {
  vpc_id     = aws_vpc.vpc.id
  cidr_block = "10.0.1.0/24"
  availability_zone = "ap-northeast-1a"
  tags = {
    Name = "${var.project_name}-sub-subnet-a"
  }
}

resource "aws_subnet" "subnet_b" {
  vpc_id     = aws_vpc.vpc.id
  cidr_block = "10.0.2.0/24"
  availability_zone = "ap-northeast-1c"
  tags = {
    Name = "${var.project_name}-sub-subnet-b"
  }
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

  tags = {
    Name = "${var.project_name}-security-group"
  }
}

# インターネットゲートウェイを作成する
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.vpc.id
}

# パブリックサブネットのルートテーブルを作成する
resource "aws_route_table" "public_route_table" {
  vpc_id = aws_vpc.vpc.id
}

# パブリックサブネットにルートテーブルを関連付ける
resource "aws_route_table_association" "public_association" {
  subnet_id      = aws_subnet.subnet.id
  route_table_id = aws_route_table.public_route_table.id
}

# パブリックルートを作成する
resource "aws_route" "public_route" {
  route_table_id         = aws_route_table.public_route_table.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.igw.id
}
