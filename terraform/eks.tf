locals {
  cluster_name                 = var.eks_cluster_name
  managed-node-group_role_name = "${local.cluster_name}-eks-managed-node-group"
}
data "aws_caller_identity" "current" {}
data "aws_availability_zones" "available" {}
################################################################################
# EKS Module
################################################################################

module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "19.10.1"

  cluster_name                   = local.cluster_name
  cluster_version                = var.eks_version
  cluster_endpoint_public_access = true
  cluster_service_ipv4_cidr      = var.cluster_service_ipv4_cidr
  cluster_ip_family              = "ipv4"
  create_cni_ipv6_iam_policy     = false

  cluster_addons = {
    coredns = {
      most_recent = true
    }
    kube-proxy = {
      most_recent = true
    }
    vpc-cni = {
      most_recent = true


    }
  }

  vpc_id     = module.vpc.vpc_id
  subnet_ids = module.vpc.private_subnets


  manage_aws_auth_configmap = true
  aws_auth_roles            = var.aws_auth_roles
  /*
  aws_auth_roles = concat(
    var.aws_auth_roles,
    [
      {
        rolearn  = module.ec2_jumpbox.iam_role_arn
        username = "jumpbox-admin"
        groups = [
          "system:masters"
        ]
      }
    ]
  )
*/
  aws_auth_users    = var.map_users
  aws_auth_accounts = var.map_accounts

  eks_managed_node_groups = {
    complete = {
      name                       = local.cluster_name
      use_name_prefix            = true
      subnet_ids                 = module.vpc.private_subnets
      min_size                   = var.eks_nodes_group_min_size
      max_size                   = var.eks_nodes_group_max_size
      desired_size               = var.eks_nodes_group_desired_size
      ami_id                     = data.aws_ami.eks_default.image_id
      enable_bootstrap_user_data = true
      capacity_type              = var.eks_nodes_group_capacity_type
      force_update_version       = true
      instance_types             = var.eks_nodes_group_instance_types
      key_name                   = local.common_key_pair
      update_config = {
        max_unavailable_percentage = var.max_unavailable_percentage
      }

      description             = "EKS managed node group ${local.cluster_name} launch template"
      ebs_optimized           = true
      disable_api_termination = false
      enable_monitoring       = true

      block_device_mappings = {
        xvda = {
          device_name = "/dev/xvda"
          ebs = {
            volume_size           = var.eks_nodes_group_root_volume_size
            volume_type           = var.eks_nodes_group_root_volume_type
            iops                  = var.eks_nodes_group_iops
            throughput            = var.eks_nodes_group_throughput
            encrypted             = true
            kms_key_id            = module.ebs_kms_key.key_arn
            delete_on_termination = true
          }
        }
      }

      metadata_options = {
        http_endpoint               = "enabled"
        http_tokens                 = "required"
        http_put_response_hop_limit = 2
        instance_metadata_tags      = "disabled"
      }

      create_iam_role          = true
      iam_role_name            = "${local.cluster_name}-eks-managed-node-group"
      iam_role_use_name_prefix = false
      iam_role_description     = "EKS managed node group role for ${local.cluster_name}"
      iam_role_tags            = local.common_tags
      iam_role_additional_policies = {
        AmazonEC2ContainerRegistryReadOnly = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
        AmazonSSMManagedInstanceCore       = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
        additional                         = aws_iam_policy.node_additional.arn
      }

      tags = merge(
        local.common_tags,
        {
          Name : local.cluster_name
        }
      )
    }
  }

  tags = merge(
    local.common_tags,
    {
      Name : local.cluster_name
      "karpenter.sh/discovery" = local.cluster_name
    }
  )
}

################################################################################
# Supporting Resources
################################################################################

module "ebs_kms_key" {
  source  = "terraform-aws-modules/kms/aws"
  version = "~> 1.5"

  description = "Customer managed key to encrypt EKS managed node group volumes"
  key_administrators = [
    data.aws_caller_identity.current.arn
  ]

  key_service_roles_for_autoscaling = [
    # required for the ASG to manage encrypted volumes for nodes
    "arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/aws-service-role/autoscaling.amazonaws.com/AWSServiceRoleForAutoScaling",
    # required for the cluster / persistentvolume-controller to create encrypted PVCs
    module.eks.cluster_iam_role_arn,
  ]
  aliases = ["eks/${local.cluster_name}/ebs"]
  tags    = local.common_tags
}


resource "aws_iam_policy" "node_additional" {
  name        = "${local.cluster_name}-additional"
  description = "Example usage of node additional policy"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "ec2:Describe*",
        ]
        Effect   = "Allow"
        Resource = "*"
      },
    ]
  })

  tags = local.common_tags
}

data "aws_ami" "eks_default" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["amazon-eks-node-${var.eks_version}-v*"]
  }
}

/*
################################################################################
# kubeconfig shell export
################################################################################

resource "null_resource" "update_kubeconfig" {
  depends_on = [module.eks]
  provisioner "local-exec" {
    command = <<EOT
        aws --region ${local.region} eks update-kubeconfig --name ${local.cluster_name} --kubeconfig ~/.kube/kubeconfig_${local.cluster_name}
        export KUBECONFIG=~/.kube/kubeconfig_${local.cluster_name}
        export KUBE_CONFIG_PATH=$KUBECONFIG
    EOT
  }
}*/

resource "aws_iam_service_linked_role" "autoscaling" {
  aws_service_name = "autoscaling.amazonaws.com"
  custom_suffix    = var.name_prefix
  lifecycle {
    ignore_changes = [aws_service_name]
  }
}
