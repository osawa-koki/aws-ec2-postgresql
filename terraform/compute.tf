
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

  associate_public_ip_address = true

  # VPCへの関連
  vpc_security_group_ids = [aws_security_group.security_group.id]
  subnet_id              = aws_subnet.subnet.id

  tags = {
    Name = "${var.project_name}-ec2"
    ResourceGroup = aws_resourcegroups_group.resource_group.name
  }
}
