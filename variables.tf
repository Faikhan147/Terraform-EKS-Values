variable "region" {
  description = "AWS region name"
  type        = string
}

variable "vpc_id" {
  type = string
  description = "VPC ID where resources will be created"
}

variable "env" {
  description = "Environment name"
  type        = string
}
