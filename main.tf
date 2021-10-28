terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.63"
    }
  }

  required_version = ">= 1.0"
}

provider "aws" {
  region = var.region
}

locals {
  App            = "Nextcloud"
  public_subnet  = "public"
  private_subnet = "private"
  dbconn_subnet  = "dbconn"
}

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
