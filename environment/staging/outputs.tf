# IAM outputs
output "iam_cluster_role_arn" {
  value       = module.iam.cluster_role_arn
  description = "ARN of EKS cluster IAM role"
}

output "iam_node_role_arn" {
  value       = module.iam.node_role_arn
  description = "ARN of EKS node IAM role"
}

# KMS outputs
output "kms_key_arn" {
  value       = module.kms.kms_key_arn
  description = "The ARN of the KMS key"
}

# Security Group outputs
output "sg_id" {
  value       = module.sg.sg_id
  description = "ID of the security group"
}
