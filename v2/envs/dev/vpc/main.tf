provider "aws" {
  region = var.region
}

module "vpc" {
  source = "../../../modules/vpc"
  region = var.region

  env = "dev"
  vpc_cidr = "10.0.0.0/16"
}
