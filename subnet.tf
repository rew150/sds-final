module "subnet_addrs" {
  source = "hashicorp/subnets/cidr"

  base_cidr_block = var.vpc_cidr
  networks = [
    {
      name     = local.public_subnet
      new_bits = 2
    },
    {
      name     = local.private_subnet
      new_bits = 2
    },
    {
      name     = local.dbconn_subnet
      new_bits = 2
    },
  ]
}

resource "aws_subnet" "public" {
  vpc_id            = aws_vpc.vpc.id
  availability_zone = var.availability_zone
  cidr_block        = module.subnet_addrs.network_cidr_blocks[local.public_subnet]

  tags = {
    Name = "${local.App}_subnet_${local.public_subnet}"
    App  = local.App
  }
}

resource "aws_subnet" "private" {
  vpc_id            = aws_vpc.vpc.id
  availability_zone = var.availability_zone
  cidr_block        = module.subnet_addrs.network_cidr_blocks[local.private_subnet]

  tags = {
    Name = "${local.App}_subnet_${local.private_subnet}"
    App  = local.App
  }
}

resource "aws_subnet" "dbconn" {
  vpc_id            = aws_vpc.vpc.id
  availability_zone = var.availability_zone
  cidr_block        = module.subnet_addrs.network_cidr_blocks[local.dbconn_subnet]

  tags = {
    Name = "${local.App}_subnet_${local.dbconn_subnet}"
    App  = local.App
  }
}
