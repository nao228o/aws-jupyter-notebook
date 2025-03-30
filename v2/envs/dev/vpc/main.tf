provider "aws" {
  region = var.region
}

module "vpc" {
  source = "../../modules/vpc"
  region = var.region

  env = "dev"
  cidr = "10.0.0.0/16"
}
