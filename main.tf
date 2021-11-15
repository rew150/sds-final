terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.63"
    }

    cloudinit = {
      source  = "hashicorp/cloudinit"
      version = "2.2.0"
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
  is_windows     = substr(pathexpand("~"), 0, 1) == "/" ? false : true
}
