resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.vpc.id

  tags = {
    Name = "${local.App}_gw"
    App  = local.App
  }
}

resource "aws_eip" "ngw" {
  vpc = true

  depends_on = [
    aws_internet_gateway.gw
  ]

  tags = {
    Name = "${local.App}_eip_ngw"
    App  = local.App
  }
}

resource "aws_nat_gateway" "ngw" {
  connectivity_type = "public"
  allocation_id     = aws_eip.ngw.id
  subnet_id         = aws_subnet.public.id

  depends_on = [
    aws_internet_gateway.gw
  ]

  tags = {
    Name = "${local.App}_ngw"
    App  = local.App
  }
}

output "ngw_eip" {
  value = aws_eip.ngw.public_ip
}
