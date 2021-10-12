module "vpc" {

  source          = "terraform-aws-modules/vpc/aws"
  name            = var.vpc_name
  cidr            = var.vpc-cidr
  azs             = [var.zone1, var.zone2, var.zone3]
  private_subnets = [var.privatesubnet1, var.privatesubnet2, var.privatesubnet3]
  public_subnets  = [var.publicsubnet1, var.publicsubnet2, var.publicsubnet3]

  enable_nat_gateway   = true
  single_nat_gateway   = true
  enable_dns_hostnames = true
  enable_dns_support   = true


  tags = {
    Terraform  = "true"
    Enviroment = "Dev"
    Project    = "CVEngine"
    Owner      = "Roshan"
  }


  vpc_tags = {
    Name = var.vpc_name
  }
}

