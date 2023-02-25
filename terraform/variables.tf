
variable "project_name" {
  description = "Project name"
  type        = string
}

variable "region" {
  description = "AWS region"
  type        = string
  default    = "ap-northeast-1"
}

variable "allowed_ip_address" {
  description = "Allowed IP address"
  type        = string
}

variable "ssh_private_key_path" {
  description = "SSH private key path"
  type        = string
  default     = "~/.ssh/id_rsa"
}

variable "ssh_public_key_path" {
  description = "SSH public key path"
  type        = string
  default     = "~/.ssh/id_rsa.pub"
}

variable "db_username" {
  description = "DB username"
  type        = string
  default     = "admin"
}

variable "db_password" {
  description = "DB password"
  type        = string
  default     = "admin"
}

variable "db_database" {
  description = "DB name"
  type        = string
  default     = "my_db"
}
