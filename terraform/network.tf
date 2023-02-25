
# VPCを作成
resource "aws_vpc" "vpc" {
  cidr_block = "10.0.0.0/16"
  enable_dns_hostnames = true // DBマイグレーション用
  enable_dns_support   = true // DBマイグレーション用
  tags = {
    Name = "${var.project_name}-vpc"
  }
}

resource "aws_db_subnet_group" "subnet_group" {
  name       = "${var.project_name}-subnet-group"
  subnet_ids = [aws_subnet.subnet_public.id, aws_subnet.subnet_a.id, aws_subnet.subnet_b.id]
  tags = {
    Name = "${var.project_name}-db-subnet-group"
  }
}

# サブネットを作成
resource "aws_subnet" "subnet_public" {
  vpc_id     = aws_vpc.vpc.id
  cidr_block = "10.0.0.0/24"
  map_public_ip_on_launch = true
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

# インターネットゲートウェイを作成する
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.vpc.id
  tags = {
    Name = "${var.project_name}-igw"
  }
}

# パブリックサブネットのルートテーブルを作成する
resource "aws_route_table" "public_route_table" {
  vpc_id = aws_vpc.vpc.id
  tags = {
    Name = "${var.project_name}-public-route-table"
  }
}

# パブリックサブネットにルートテーブルを関連付ける
resource "aws_route_table_association" "public_association" {
  subnet_id      = aws_subnet.subnet_public.id
  route_table_id = aws_route_table.public_route_table.id
}

# パブリックルートを作成する
resource "aws_route" "public_route" {
  route_table_id         = aws_route_table.public_route_table.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.igw.id
}
