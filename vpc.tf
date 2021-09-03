locals {
  public_private_subnets = cidrsubnets(var.vpc_cidr, 4, 4)
}

module "vpc" {
  source = "terraform-aws-modules/vpc/aws"

  name = "${var.application_name}-vpc"
  cidr = var.vpc_cidr

  azs             = ["${var.region}a", "${var.region}b", "${var.region}c"]
  private_subnets = cidrsubnets(local.public_private_subnets[0], 4, 4, 4)
  public_subnets  = cidrsubnets(local.public_private_subnets[1], 4, 4, 4)

  enable_nat_gateway = true
  enable_vpn_gateway = false

  tags = local.common_tags
}