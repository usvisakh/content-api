################################################################################
# Common Variables
################################################################################
region      = "us-east-2"
environment = "poc"
name_prefix = "cognianxtgen"
secret_name = "cognianxtgen"
################################################################################
# VPC Variables
################################################################################
vpc_cidr           = "10.21.48.0/21"
azs                = ["us-east-2a", "us-east-2b"]
public_subnets     = ["10.21.48.0/23", "10.21.50.0/23"]
public_subnet_name = ["Public-Subnet-1", "Public-Subnet-2"]

private_subnets     = ["10.21.52.0/23", "10.21.54.0/23"]
private_subnet_name = ["Private-Subnet-1", "Private-Subnet-2"]

################################################################################
# EKS Variables
################################################################################
eks_version      = "1.25"
eks_cluster_name = "cognianxtgen"
aws_auth_roles = [
  {
    rolearn = "arn:aws:iam::252078852689:role/AWSReservedSSO_AdministratorAccess_aab8ea59e7b51b87"

    username = "sso-admin"
    groups = [
      "system:masters"
    ]
  }

]

map_accounts = ["252078852689", ]
map_users = [
  {
    userarn  = "arn:aws:iam::252078852689:user/Af-Visakh"
    username = "Visakh"
    groups   = ["system:masters"]
  }
]




################################################################################
#R53
################################################################################

zone_name     = "cognia.epiuseaws.com"
argocd_domain = "argocd.cognia.epiuseaws.com"

################################################################################
# Aurora Cluster Variables
################################################################################
aurora_name                           = "cognianxtgen"
engine_version                        = "15.2"
writer_instance_class                 = "db.t4g.medium"
performance_insights_retention_period = 7
automatic_backup_retention_period     = 7
################################################################################
# ECR Variables
################################################################################
ecr_name    = "cognianxtgen"
ecr_mutable = "MUTABLE"
ecr_type    = "private"
