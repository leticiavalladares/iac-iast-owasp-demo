resource "aws_db_instance" "rds" {
  allocated_storage    = 10
  db_name              = "juiceshop"
  engine               = "mysql"
  engine_version       = "8.0.32"
  instance_class       = "db.t3.small"
  username             = jsondecode(nonsensitive(data.aws_secretsmanager_secret_version.db_secrets.secret_string))["MYSQL_USER"]
  password             = jsondecode(nonsensitive(data.aws_secretsmanager_secret_version.db_secrets.secret_string))["MYSQL_PASSWORD"]
  skip_final_snapshot  = true
  db_subnet_group_name = aws_db_subnet_group.db_sg.name

  tags = {
    Name = "db-${local.resource_suffix}"
  }
}