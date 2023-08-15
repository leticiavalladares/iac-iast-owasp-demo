resource "aws_security_group" "sg" {
  for_each = local.sg

  name        = each.key
  description = each.value.description
  vpc_id      = aws_vpc.vpc[each.value.vpc].id

  dynamic "ingress" {
    for_each = local.sg[each.key].inbound_rules

    content {
      description     = ingress.value.description
      from_port       = ingress.value.from_port
      to_port         = ingress.value.to_port
      protocol        = ingress.value.protocol
      cidr_blocks     = lookup(ingress.value, ["cidr_block"], null)
      security_groups = lookup(ingress.value, ["security_groups"], null)
    }
  }

  egress {
    description = "Allow access to the world"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}