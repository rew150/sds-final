resource "aws_route_table" "public" {
  vpc_id = aws_vpc.vpc.id

  # mapping vpc -> local was done implicitly
  # and cant be defined within terraform
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gw.id
  }

  tags = {
    Name = "${local.App}_route_table_public"
    App  = local.App
  }
}

resource "aws_route_table" "private" {
  vpc_id = aws_vpc.vpc.id

  # mapping vpc -> local was done implicitly
  # and cant be defined within terraform
  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.ngw.id
  }

  tags = {
    Name = "${local.App}_route_table_private"
    App  = local.App
  }
}

resource "aws_route_table_association" "public" {
  subnet_id      = aws_subnet.public.id
  route_table_id = aws_route_table.public.id
}

resource "aws_route_table_association" "private" {
  subnet_id      = aws_subnet.private.id
  route_table_id = aws_route_table.private.id
}
