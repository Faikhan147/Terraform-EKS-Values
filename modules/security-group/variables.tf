variable "vpc_id" {
  type = string
  description = "VPC ID where resources will be created"
}

variable "env" {
  description = "Environment name"
  type        = string
}
