resource "aws_vpc" "vpc" {
  cidr_block = var.vpc_cidr

  tags = {
    Name = "${local.App}_vpc"
    App  = local.App
  }
}
