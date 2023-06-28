data "aws_route53_zone" "zone" {
  name = var.zone_name
}

resource "helm_release" "metrics_server" {
  depends_on = [module.eks]
  name       = "metrics-server"
  repository = "https://charts.bitnami.com/bitnami"
  chart      = "metrics-server"
  version    = "6.2.12"
  namespace  = "kube-system"
  values = [
    file("./templates/metrics-server/values.yaml")
  ]
}

module "external_dns" {
  depends_on                       = [module.eks]
  source                           = "DNXLabs/eks-external-dns/aws"
  version                          = "0.2.0"
  cluster_name                     = module.eks.cluster_name
  cluster_identity_oidc_issuer     = module.eks.cluster_oidc_issuer_url
  cluster_identity_oidc_issuer_arn = module.eks.oidc_provider_arn
  helm_chart_version               = "6.14.2"
  policy_allowed_zone_ids          = [data.aws_route53_zone.zone.zone_id]
  create_namespace                 = false
  settings = {
    "policy"          = "sync" # Modify how DNS records are sychronized between sources and providers.
    "zoneIdFilters"   = [data.aws_route53_zone.zone.zone_id]
    "aws.preferCNAME" = "true"
  }
}


module "load_balancer_controller" {
  depends_on                       = [module.eks]
  source                           = "DNXLabs/eks-lb-controller/aws"
  version                          = "0.7.0"
  enabled                          = true
  cluster_identity_oidc_issuer     = module.eks.cluster_oidc_issuer_url
  cluster_identity_oidc_issuer_arn = module.eks.oidc_provider_arn
  cluster_name                     = module.eks.cluster_name
  helm_chart_version               = "1.4.8"

}


module "cluster-autoscaler_helm" {
  depends_on                       = [module.eks]
  source                           = "lablabs/eks-cluster-autoscaler/aws"
  version                          = "2.0.0"
  enabled                          = true
  cluster_name                     = module.eks.cluster_name
  cluster_identity_oidc_issuer     = module.eks.cluster_oidc_issuer_url
  cluster_identity_oidc_issuer_arn = module.eks.oidc_provider_arn
  helm_create_namespace            = false
  namespace                        = "kube-system"

}

################################################################################
# Karpenter
################################################################################
#-------------------------------------------------------------
# karpenter
#------------------------------------------------------------
resource "helm_release" "karpenter" {
  depends_on       = [module.eks]
  namespace        = "karpenter"
  create_namespace = true
  name             = "karpenter"
  repository       = "https://charts.karpenter.sh"
  chart            = "karpenter"
  version          = "v0.16.3"

  set {
    name  = "serviceAccount.annotations.eks\\.amazonaws\\.com/role-arn"
    value = module.iam_assumable_role_karpenter.iam_role_arn
  }

  set {
    name  = "clusterName"
    value = local.cluster_name
  }

  set {
    name  = "clusterEndpoint"
    value = module.eks.cluster_endpoint
  }
}


#-------------------------------------------------------------
# IAM Role for karpenter
#------------------------------------------------------------

resource "aws_iam_instance_profile" "karpenter" {
  name = "KarpenterNodeInstanceProfile-${local.cluster_name}"
  role = local.managed-node-group_role_name
}

#KarpenterController IAM Role

module "iam_assumable_role_karpenter" {
  source                        = "terraform-aws-modules/iam/aws//modules/iam-assumable-role-with-oidc"
  version                       = "4.7.0"
  create_role                   = true
  role_name                     = "karpenter-controller-${local.cluster_name}"
  provider_url                  = module.eks.cluster_oidc_issuer_url
  oidc_fully_qualified_subjects = ["system:serviceaccount:karpenter:karpenter"]
}

resource "aws_iam_role_policy" "karpenter_controller" {
  name = "karpenter-policy-${local.cluster_name}"
  role = module.iam_assumable_role_karpenter.iam_role_name

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "ec2:CreateLaunchTemplate",
          "ec2:CreateFleet",
          "ec2:RunInstances",
          "ec2:CreateTags",
          "iam:PassRole",
          "ec2:TerminateInstances",
          "ec2:DescribeLaunchTemplates",
          "ec2:DescribeInstances",
          "ec2:DescribeSecurityGroups",
          "ec2:DescribeSubnets",
          "ec2:DescribeInstanceTypes",
          "ec2:DescribeInstanceTypeOfferings",
          "ec2:DescribeAvailabilityZones",
          "ssm:GetParameter",
          "iam:CreateServiceLinkedRole",
          "iam:ListRoles",
          "iam:ListInstanceProfiles",
        ]
        Effect   = "Allow"
        Resource = "*"
      },
      {
        Action = [
          "kms:*"
        ]
        Effect   = "Allow"
        Resource = module.ebs_kms_key.key_arn
      },

    ]
  })
}


#-------------------------------------------------------------
# EKS provisioner
#------------------------------------------------------------

data "template_file" "karpenter" {
  depends_on = [module.eks]
  template   = file("./templates/karpenter/provisioner.yaml")
  vars = {
    CLUSTER_NAME     = local.cluster_name
    EBS_KMS_ARN      = module.ebs_kms_key.key_arn
    ENVIRONMENT      = var.environment
    NAMEPREFIX       = var.name_prefix
    INSTANCE_PROFILE = "KarpenterNodeInstanceProfile-${local.cluster_name}"
    CLUSTER_SG_NAME  = "${var.eks_cluster_name}-node"
  }
}


resource "kubectl_manifest" "karpenter_provisioner" {
  depends_on = [helm_release.karpenter]
  yaml_body  = data.template_file.karpenter.rendered


}


