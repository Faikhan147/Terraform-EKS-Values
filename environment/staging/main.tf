provider "aws" {
  region = var.region
}

terraform {
  required_version = ">= 1.5.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.14.0"
    }
  }
}

module "iam" {
  source      = "../../modules/iam"
  env         = var.env
}

module "kms" {
  source      = "../../modules/kms"
  env         = var.env
}

module "sg" {
  source      = "../../modules/security-group"
  env         = var.env
  vpc_id      = var.vpc_id
}
