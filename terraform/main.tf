
provider "aws" {
  region = var.region
}

resource "aws_resourcegroups_group" "resource_group" {
  name = "${var.project_name}-resource-group"
  tags = {
    Name        = "${var.project_name}-resource-group"
    Terraform   = "true"
    Environment = "dev"
  }
}
