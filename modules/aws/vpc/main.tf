module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "5.19.0"

  cidr                 = var.vpc_cidr_block
  azs                  = var.vpc_azs
  private_subnets      = var.vpc_subnet_cidrs
  public_subnets       = var.vpc_public_subnet_cidrs
  enable_dns_hostnames = true

  tags = {
    Environment = var.environment
    ManagedBy   = var.managed_by
    Name        = var.vpc_name
  }
}
