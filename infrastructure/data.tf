data "aws_region" "current_region" {}

data "aws_ami" "amazon_linux_image" {
  owners      = ["137112412989"]
  most_recent = true

  filter {
    name   = "name"
    values = ["amzn2-ami-kernel-5.10-hvm-2.0.20230727.0-x86_64-gp2"]
  }
}

data "aws_secretsmanager_secret" "db_secret" {
  name = "owasp-juice-shop-db-secret"
}

data "aws_secretsmanager_secret_version" "db_secrets" {
  secret_id = data.aws_secretsmanager_secret.db_secret.id
}