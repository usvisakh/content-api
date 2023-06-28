
module "ecr" {
  source  = "terraform-aws-modules/ecr/aws"
  version = "1.6.0"

  repository_name                 = var.ecr_name
  repository_type                 = var.ecr_type
  repository_image_tag_mutability = var.ecr_mutable
  repository_image_scan_on_push   = var.ecr_scan_on_push
  create_lifecycle_policy         = false
  tags                            = local.common_tags
}
