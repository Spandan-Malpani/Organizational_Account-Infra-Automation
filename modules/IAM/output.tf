###############################
# VPC Flow Log Role
###############################
output "flow_log_role_arn" {
  description = "ARN of the VPC Flow Log IAM role"
  value       = aws_iam_role.flow_log_role.arn
}

output "flow_log_role_name" {
  description = "Name of the VPC Flow Log IAM role"
  value       = aws_iam_role.flow_log_role.name
}

###############################
# AWS Support Role
###############################
output "aws_support_role_arn" {
  description = "ARN of the AWS Support access role"
  value       = aws_iam_role.aws_support_role.arn
}

output "aws_support_role_name" {
  description = "Name of the AWS Support access role"
  value       = aws_iam_role.aws_support_role.name
}

###############################
# Policy Attachments
###############################
output "support_policy_attachment_id" {
  description = "ID of the AWS Support policy attachment"
  value       = aws_iam_role_policy_attachment.aws_support_role_policy_attachment.id
}

output "vpc_flow_log_policy_id" {
  description = "ID of the VPC Flow Log policy"
  value       = aws_iam_role_policy.vpc_flow_log_policy.id
}



