resource "aws_instance" "app_server" {
  ami                    = data.aws_ami.ubuntu_image.id
  instance_type          = "t3.medium"
  iam_instance_profile   = aws_iam_instance_profile.instance_profile.name
  subnet_id              = aws_subnet.subnet["pub-1"].id
  vpc_security_group_ids = [aws_security_group.sg["app-sg"].id]

  user_data = templatefile("${path.module}/bootstrap/user-data.sh",
    {
      db_endpoint = aws_db_instance.rds.address,
      db_user     = jsondecode(nonsensitive(data.aws_secretsmanager_secret_version.db_secrets.secret_string))["MYSQL_USER"],
      db_password = jsondecode(nonsensitive(data.aws_secretsmanager_secret_version.db_secrets.secret_string))["MYSQL_PASSWORD"]
  })

  tags = {
    Name = "ec2-${local.resource_suffix}"
  }

  depends_on = [
    aws_db_instance.rds
  ]
}