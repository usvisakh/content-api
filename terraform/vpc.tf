module "vpc" {
  source                        = "terraform-aws-modules/vpc/aws"
  version                       = "5.0.0"
  name                          = "${var.name_prefix}-vpc"
  cidr                          = var.vpc_cidr
  azs                           = var.azs
  public_subnets                = var.public_subnets
  public_subnet_names           = var.public_subnet_name
  private_subnets               = var.private_subnets
  private_subnet_names          = var.private_subnet_name
  enable_nat_gateway            = true
  single_nat_gateway            = false
  one_nat_gateway_per_az        = true
  manage_default_security_group = true
  enable_dns_hostnames          = true
  default_security_group_name   = "${var.name_prefix}_default_sg"
  private_subnet_tags = {
    "kubernetes.io/cluster/${local.cluster_name}" = "owned"
    "kubernetes.io/role/internal-elb"             = "1",
    "karpenter.sh/discovery"                      = local.cluster_name
  }

  public_subnet_tags = {
    "kubernetes.io/role/elb" = "1"
  }
  default_security_group_ingress = [
    { cidr_blocks = var.vpc_cidr
      description = "vpc default sg"
      from_port   = 0
      to_port     = 0
      protocol    = -1
    }
  ]
  default_security_group_egress = [
    { cidr_blocks = "0.0.0.0/0"
      description = "vpc default sg"
      from_port   = 0
      to_port     = 0
      protocol    = -1
    }
  ]

  enable_flow_log                      = true
  create_flow_log_cloudwatch_log_group = true
  create_flow_log_cloudwatch_iam_role  = true
  flow_log_max_aggregation_interval    = 60
  tags                                 = local.common_tags
}

