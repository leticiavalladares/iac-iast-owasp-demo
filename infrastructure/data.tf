data "aws_region" "current_region" {}

data "aws_ami" "ubuntu_image" {
  owners      = ["099720109477"]
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
  }
}

data "aws_secretsmanager_secret" "db_secret" {
  name = "owasp-juice-shop-db-secret"
}

data "aws_secretsmanager_secret_version" "db_secrets" {
  secret_id = data.aws_secretsmanager_secret.db_secret.id
}