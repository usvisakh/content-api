################################################################################
# Common Variables
################################################################################

variable "environment" {
  description = "AWS Environment"
  default     = ""
}

variable "name_prefix" {
  description = "project name prifix"
  default     = ""
}

variable "region" {
  description = "AWS Region"
  default     = "us-east-1"
}

variable "secret_name" {
  description = "Secret manager name for DB and Key secrets"
  default     = ""
}
################################################################################
# VPC Variables
################################################################################


variable "vpc_cidr" {
  description = "vpc cidr block"
  default     = ""
}
variable "azs" {
  description = "Availability zones"
  default     = []
}

variable "private_subnets" {
  description = "private subnet cidr block"
  default     = []
}

variable "public_subnets" {
  description = "public subnet cidr block"
  default     = []
}

variable "public_subnet_name" {
  description = "Name of public_subnet"
  default     = []
}

variable "private_subnet_name" {
  description = "Name of private subnets"
  default     = []
}


################################################################################
# EKS Variables
################################################################################

variable "eks_version" {
  description = "EKS cluster version"
  default     = "1.25"
}

variable "eks_cluster_name" {
  type    = string
  default = "eks-cluster"
}


variable "cluster_service_ipv4_cidr" {
  description = "EKS cluster drivice ipv4 cidr"
  type        = string
  default     = "172.20.0.0/16"
}

variable "map_users" {
  description = "EKS auth config map users"
  default     = []
}

variable "aws_auth_roles" {
  description = "EKS auth config map roles"
  default     = []
}


variable "map_accounts" {
  description = "Additional AWS account numbers to add to the aws-auth configmap."
  type        = list(string)
  default     = []
}

variable "eks_nodes_group_min_size" {
  default = "1"
}

variable "eks_nodes_group_max_size" {
  default = "10"
}

variable "eks_nodes_group_desired_size" {
  default = "1"
}

variable "eks_nodes_group_capacity_type" {
  default = "ON_DEMAND"
}

variable "eks_nodes_group_instance_types" {
  description = "EKS cluster instance typs, can be choose multiple instance types with same CPU and Memory spec"
  default     = ["m5.xlarge"]
}


variable "max_unavailable_percentage" {
  default = 20
}


variable "eks_nodes_group_root_volume_size" {
  default = "50"
}

variable "eks_nodes_group_root_volume_type" {
  default = "gp3"
}

variable "eks_nodes_group_iops" {
  default = 3000
}

variable "eks_nodes_group_throughput" {
  default = 150
}


################################################################################
#R53
################################################################################
variable "zone_name" {
  description = "Route53 Zone name"
  type        = string
  default     = ""
}

variable "argocd_domain" {
  description = "argocd domain name"
  type        = string
  default     = ""
}
################################################################################
# Aurora Cluster Variables
################################################################################

variable "aurora_name" {
  description = "aurora cluster name"
  default     = ""
}

variable "engine_version" {
  description = "aurora cluster engine version"
  default     = "14.6"
}

variable "auto_minor_version_upgrade" {
  description = "aurora cluster auto minor version upgrade"
  default     = false
}

variable "allow_major_version_upgrade" {
  description = "aurora cluster major version upgrade"
  default     = false
}

variable "writer_instance_class" {
  description = "aurora cluster writer instance class"
  default     = false
}

variable "reader_instance_class" {
  description = "aurora cluster reader instance class"
  default     = false
}


variable "db_cluster_db_instance_parameter_group_name" {
  description = "aurora cluster db instance parameter group name"
  default     = "postgress14"
}


variable "performance_insights_retention_period" {
  description = "aurora cluster performance insights retention period maximum 7 days"
  default     = 7
}


variable "automatic_backup_retention_period" {
  description = "aurora cluster automatic backup retention period amximum 35 days"
  default     = 7
}


################################################################################
# ECR Variables
################################################################################

variable "ecr_name" {
  description = "ecr name"
  type        = string
  default     = "eks-test"
}

variable "ecr_mutable" {
  description = "ecr mutable"
  type        = string
  default     = "MUTABLE"
}

variable "ecr_scan_on_push" {
  description = "ecr scan on push"
  type        = bool
  default     = true
}

variable "ecr_type" {
  description = "ecr role name"
  type        = string
  default     = "private"
}
