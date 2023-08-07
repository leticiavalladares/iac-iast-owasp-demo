resource "aws_internet_gateway" "ig_external_vpc" {
  vpc_id = aws_vpc.vpc["prod"].id

  tags = {
    Name = "igw-${local.resource_suffix}"
  }
}

resource "aws_eip" "nat_eip" {
  domain = "vpc"
}

resource "aws_nat_gateway" "nat_external_vpc" {
  allocation_id = aws_eip.nat_eip.id
  subnet_id     = aws_subnet.subnet["pub-1"].id

  tags = {
    Name = "appnat-${local.resource_suffix}"
  }

  depends_on = [aws_internet_gateway.ig_external_vpc]
}