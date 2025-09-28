module "kms" {
  source      = "../../modules/kms"
  env         = var.env
}

module "iam" {
  source      = "../../modules/iam"
  env         = var.env
}

module "sg" {
  source      = "../../modules/security-group"
  env         = var.env
  vpc_id      = var.vpc_id
}
