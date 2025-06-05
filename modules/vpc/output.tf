output "vpc_id" {
  description = "The ID of the VPC"
  value       = aws_vpc.custom.id
}

output "vpc_cidr" {
  description = "The CIDR block of the VPC"
  value       = aws_vpc.custom.cidr_block
}

output "public_subnet_ids" {
  value       = [aws_subnet.public_subnet[*].id]
  description = "The IDs of the public subnets."
}

# Output the CIDR blocks of the public subnets
output "public_subnet_cidr_blocks" {
  value       = [aws_subnet.public_subnet[*].cidr_block]
  description = "The CIDR blocks of the public subnets."
}

# Output the IDs of the private subnets
output "private_subnet_ids" {
  value       = [aws_subnet.private_subnet[*].id]
  description = "The IDs of the private subnets."
}

# Output the CIDR blocks of the private subnets
output "private_subnet_cidr_blocks" {
  value       = [aws_subnet.private_subnet[*].cidr_block]
  description = "The CIDR blocks of the private subnets."
}

output "gwlbe_subnet_ids" {
  description = "List of IDs of GWLBE subnets"
  value       = [aws_subnet.gwlbe_subnet[*].id]
}

output "vpc_endpoint_ids" {
  description = "List of VPC Endpoint IDs"
  value       = [aws_vpc_endpoint.gwlbe[*].id]
}

output "public_route_table_ids" {
  description = "List of IDs of public route tables"
  value       = [aws_route_table.public_rt[*].id]
}

output "private_route_table_ids" {
  description = "List of IDs of private route tables"
  value       = [aws_route_table.private_rt[*].id]
}

output "gwlbe_route_table_id" {
  description = "ID of the GWLBE route table"
  value       = [aws_route_table.gwlbe_rt[*].id]
}

output "gwlb_ingress_route_table_id" {
  description = "ID of the GWLB ingress route table"
  value       = aws_route_table.gwlb_ingress.id
}

output "internet_gateway_id" {
  description = "ID of the Internet Gateway"
  value       = aws_internet_gateway.main.id
}

output "vpc_flow_log_group_arn" {
  description = "ARN of the VPC Flow Logs CloudWatch Log Group"
  value       = aws_cloudwatch_log_group.vpc_flow_logs_group.arn
}

output "vpc_flow_log_id" {
  description = "ID of the VPC Flow Log"
  value       = aws_flow_log.vpc_flow_log.id
}

