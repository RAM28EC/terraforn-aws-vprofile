module "vpc" {
  source               = "terraform-aws-modules/vpc/aws"
  name                 = var.VPC_NAME
  cidr                 = var.VpcCIDR
  azs                  = [var.zone1, var.zone2, var.zone3]
  private_subnets      = [var.PrivbSub1CIDR, var.PrivbSub2CIDR, var.PrivbSub3CIDR]
  public_subnets       = [var.PubSub1CIDR, var.PubSub2CIDR, var.PubSub3CIDR]
  enable_nat_gateway   = true
  enable_vpn_gateway   = true
  enable_dns_hostnames = true
  enable_dns_support   = true
  tags                 = {
    Terraform   = "true"
    Environment = "Prod"
  }
  vpc_tags = {
    Name = var.VPC_NAME
  }
}


