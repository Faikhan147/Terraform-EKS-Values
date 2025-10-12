# backend.tf (real-time companies style)

terraform {
  backend "s3" {
    bucket         = "terraform-backend-all-envs"
    key            = "eks/values/prod/terraform.tfstate"
    region         = "ap-southeast-2"
    encrypt        = true
    dynamodb_table = "terraform-locks-values-prod"
  }
}
