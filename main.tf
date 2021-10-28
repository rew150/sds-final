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
