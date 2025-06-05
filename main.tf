# IAM module should be first as other modules might depend on IAM roles
module "iam" {
  source = "./modules/IAM"

  flow_log_role_name               = var.flow_log_role_name
  aws_support_role_name            = var.aws_support_role_name
  account_id                       = var.account_id
  #role_name                       = var.role_name
}

# VPC module with dependency on IAM for flow logs
module "vpc" {
  source = "./modules/vpc"

  depends_on = [module.iam]

  vpc_name              = var.vpc_name
  vpc_cidr_block        = var.vpc_cidr_block
  igw_name              = var.igw_name
  subnet_configurations = var.subnet_configurations
  gwlbe_subnet_cidrs    = var.gwlbe_subnet_cidrs
  gwlbe_subnet_azs      = var.gwlbe_subnet_azs
  map_public_ip         = var.map_public_ip
  gwlbe_service_name    = var.gwlbe_service_name
  tags                  = var.tags
  # Flow log configuration
  log_group_name                       = var.log_group_name
  log_retention_days                   = var.log_retention_days
  log_group_class                      = var.log_group_class
  flow_log_role_arn                    = module.iam.flow_log_role_arn
  flow_log_role_name                   = var.flow_log_role_name
  flow_log_traffic_type                = var.flow_log_traffic_type
  flowlog_format                       = var.flowlog_format
  flowlog_maximum_aggregation_interval = var.flowlog_maximum_aggregation_interval

  # DNS settings
  enable_dns_hostnames = var.enable_dns_hostnames
  enable_dns_support   = var.enable_dns_support

  #IAM 
  aws_support_role_name            = var.aws_support_role_name
  account_id                       = var.account_id
  #role_name                       = var.role_name

}

# Security module after IAM is set up
module "security" {
  source = "./modules/Security"

  depends_on = [module.iam]

  password_policy = var.password_policy

  aws_region = var.aws_region
}
