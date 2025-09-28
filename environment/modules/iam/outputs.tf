output "cluster_role_arn" {
  value       = aws_iam_role.cluster_role.arn
  description = "ARN of EKS cluster role"
}

output "node_role_arn" {
  value       = aws_iam_role.node_role.arn
  description = "ARN of EKS node role"
}
