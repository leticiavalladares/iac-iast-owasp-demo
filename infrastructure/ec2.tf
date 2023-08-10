resource "aws_instance" "app_server" {
  for_each = local.appservers

  ami                    = data.aws_ami.amazon_linux_image.id
  instance_type          = each.value.type
  iam_instance_profile   = aws_iam_instance_profile.instance_profile.name
  subnet_id              = aws_subnet.subnet["pub-1"].id
  vpc_security_group_ids = [aws_security_group.sg["app-sg"].id]
  key_name               = "talent-academy-git.pub"

  user_data = templatefile("${path.module}/bootstrap/${each.value.user_data}",
    {
      db_endpoint = aws_db_instance.rds.address,
      db_user     = jsondecode(nonsensitive(data.aws_secretsmanager_secret_version.db_secrets.secret_string))["MYSQL_USER"],
      db_password = jsondecode(nonsensitive(data.aws_secretsmanager_secret_version.db_secrets.secret_string))["MYSQL_PASSWORD"]
  })

  tags = {
    Name = "${each.key}-${local.resource_suffix}"
  }

  depends_on = [
    aws_db_instance.rds
  ]

}