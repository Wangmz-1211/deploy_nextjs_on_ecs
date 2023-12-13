module "ecr" {
  source                          = "terraform-aws-modules/ecr/aws"
  repository_name                 = var.app_name
  repository_type                 = "private"
  repository_image_tag_mutability = "MUTABLE"

  create_lifecycle_policy = false
}