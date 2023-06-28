

################################################################################
# RDS Module
################################################################################
locals {
  aurora_name = var.aurora_name
}

################################################################################
# RDS Aurora Module
################################################################################

module "aurora" {
  depends_on = [module.vpc]
  source     = "terraform-aws-modules/rds-aurora/aws"
  version    = "7.7.0"

  name                        = local.aurora_name
  engine                      = "aurora-postgresql"
  engine_version              = var.engine_version
  allow_major_version_upgrade = var.allow_major_version_upgrade
  auto_minor_version_upgrade  = var.auto_minor_version_upgrade

  instances = {
    1 = {
      identifier     = "${local.aurora_name}-db-1"
      instance_class = var.writer_instance_class
    }
  }


  vpc_id                 = module.vpc.vpc_id
  create_db_subnet_group = true
  subnets                = module.vpc.private_subnets
  create_security_group  = true
  allowed_cidr_blocks    = [module.vpc.vpc_cidr_block]
  security_group_egress_rules = {
    to_cidrs = {
      cidr_blocks = ["0.0.0.0/0"]
      description = "Egress to corporate printer closet"
    }
  }

  iam_database_authentication_enabled = true
  database_name                       = jsondecode(data.aws_secretsmanager_secret_version.eks_secret.secret_string)["db_name"]
  master_username                     = jsondecode(data.aws_secretsmanager_secret_version.eks_secret.secret_string)["db_user"]
  master_password                     = jsondecode(data.aws_secretsmanager_secret_version.eks_secret.secret_string)["db_password"]
  create_random_password              = false

  apply_immediately   = true
  skip_final_snapshot = true

  db_parameter_group_name                     = aws_db_parameter_group.pdb.id
  db_cluster_parameter_group_name             = aws_rds_cluster_parameter_group.cdb.id
  db_cluster_db_instance_parameter_group_name = var.db_cluster_db_instance_parameter_group_name
  backup_retention_period                     = var.automatic_backup_retention_period
  enabled_cloudwatch_logs_exports             = ["postgresql"]
  performance_insights_enabled                = true
  performance_insights_retention_period       = var.performance_insights_retention_period


  tags = merge(
    local.common_tags,
    { "backup" = "enabled" },
  )
}

resource "aws_db_parameter_group" "pdb" {
  name        = "brownandriding-aurora-db-postgres${element(split(".", var.engine_version), 0)}-parameter-group"
  family      = "aurora-postgresql${element(split(".", var.engine_version), 0)}"
  description = "${local.aurora_name}-aurora-db-postgres${element(split(".", var.engine_version), 0)}-parameter-group"
  tags        = local.common_tags
}

resource "aws_rds_cluster_parameter_group" "cdb" {
  name        = "brownandriding-aurora-postgres${element(split(".", var.engine_version), 0)}-cluster-parameter-group"
  family      = "aurora-postgresql${element(split(".", var.engine_version), 0)}"
  description = "${local.aurora_name}-aurora-postgres${element(split(".", var.engine_version), 0)}-cluster-parameter-group"
  tags        = local.common_tags
}

