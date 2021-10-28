resource "aws_vpc" "vpc" {
  cidr_block = var.vpc_cidr

  tags = {
    Name = local.App
    App  = local.App
  }
}

resource "aws_subnet" "public" {
  vpc_id            = aws_vpc.vpc.id
  availability_zone = var.availability_zone
  cidr_block        = module.subnet_addrs.network_cidr_blocks[local.public_subnet]

  tags = {
    Name = "${local.App}_${local.public_subnet}"
    App  = local.App
  }
}

resource "aws_subnet" "private" {
  vpc_id            = aws_vpc.vpc.id
  availability_zone = var.availability_zone
  cidr_block        = module.subnet_addrs.network_cidr_blocks[local.private_subnet]

  tags = {
    Name = "${local.App}_${local.private_subnet}"
    App  = local.App
  }
}

resource "aws_subnet" "dbconn" {
  vpc_id            = aws_vpc.vpc.id
  availability_zone = var.availability_zone
  cidr_block        = module.subnet_addrs.network_cidr_blocks[local.dbconn_subnet]

  tags = {
    Name = "${local.App}_${local.dbconn_subnet}"
    App  = local.App
  }
}
