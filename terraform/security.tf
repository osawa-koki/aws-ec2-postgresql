
# VPCに関する設定
resource "aws_security_group" "security_group_ec2" {
  name_prefix = "${var.project_name}-security-group-ec2"
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
    description = "Allow HTTP"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "Allow HTTPS"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # EC2アウトバウンド設定
  egress {
    description = "Allow all outbound traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.project_name}-security-group-ec2"
  }
}

# VPCに関する設定
resource "aws_security_group" "security_group_postgresql" {
  name_prefix = "${var.project_name}-security-group-postgresql"
  vpc_id      = aws_vpc.vpc.id

  ingress {
    description = "Allow PostgreSQL"
    from_port   = 5432
    to_port     = 5432
    protocol    = "tcp"
    cidr_blocks = ["${var.allowed_ip_address}/32"]
  }

  ingress {
    description = "Allow PostgreSQL (VPC)"
    from_port   = 5432
    to_port     = 5432
    protocol    = "tcp"
    cidr_blocks = [aws_subnet.subnet_public.cidr_block]
  }

  egress { // DBマイグレーション用
    description = "Allow all outbound traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.project_name}-security-group-postgresql"
  }
}
