data "aws_region" "current_region" {}

data "aws_ami" "ubuntu_image" {
  owners      = ["674577138207"]
  most_recent = true

  filter {
    name   = "name"
    values = ["Ubuntu Server 22.04 LTS (HVM) SSD Volume Type by Venv"]
  }
}

data "aws_secretsmanager_secret" "db_secret" {
  name = "owasp-juice-shop-db-secret"
}

data "aws_secretsmanager_secret_version" "db_secrets" {
  secret_id = data.aws_secretsmanager_secret.db_secret.id
}