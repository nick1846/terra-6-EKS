provider "aws" {
  region     = var.aws_region
  access_key = var.aws_access_key
  secret_key = var.aws_secret_key
}

#my vpc

data "aws_availability_zones" "azs" {
  state = "available"
}

module "my_vpc" {
  source               = "terraform-aws-modules/vpc/aws"
  name                 = var.my_vpc_name
  cidr                 = var.my_vpc_cidr
  azs                  = data.aws_availability_zones.azs.names
  private_subnets      = var.my_vpc_private_subnets
  public_subnets       = var.my_vpc_public_subnets
  enable_dns_hostnames = var.my_dns_hostnames_bool
  enable_nat_gateway   = var.my_vpc_nat_gateway_bool
  single_nat_gateway   = true
  enable_dns_support   = true
  vpc_tags             = var.my_tags

  tags = {
    "kubernetes.io/cluster/${local.cluster_name}" = "shared"
  }

  public_subnet_tags = {
    "kubernetes.io/cluster/${local.cluster_name}" = "shared"
    "kubernetes.io/role/elb"                      = "1"
  }

  private_subnet_tags = {
    "kubernetes.io/cluster/${local.cluster_name}" = "shared"
    "kubernetes.io/role/internal-elb"             = "1"
  }
}




