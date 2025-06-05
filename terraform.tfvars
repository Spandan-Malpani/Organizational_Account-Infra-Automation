#Security

# IAM Password Policy
password_policy = {
  minimum_password_length        = 14
  require_lowercase_characters   = true
  require_uppercase_characters   = true
  require_numbers                = true
  require_symbols                = true
  allow_users_to_change_password = true
  password_reuse_prevention      = 24
  max_password_age               = 90
  hard_expiry                    = false
  aws_region                     = "us-east-1"
}


#VPC
aws_region                           = "us-east-1" # region for resources to be deployed in
vpc_name                             = "Custom-VPC" # VPC name
vpc_cidr_block                       = "10.0.0.0/16" # VPC CIDR
igw_name                             = "custom-igw" # IGW name

####################################################
# Provide CIDRS for Public and Private Subnets alongwith their respective availabilty zones here
####################################################

/* EXAMPLE: 3 PUBLIC SUBNETS ARE BEING CREATED WITH 2 IN THE SAME AZ. 5 PRIVATE SUBNETS WITH 2 IN THE SAME AZ. 
ADJUST AS PER YOUR REQUIREMENT. */
subnet_configurations = {                         
  public = [
    {
      cidr_block        = "10.0.1.0/24"
      availability_zone = "us-east-1a"
    },
    {
      cidr_block        = "10.0.2.0/24"
      availability_zone = "us-east-1a"
    },
    {
      cidr_block        = "10.0.3.0/24"
      availability_zone = "us-east-1b"
    }
  ]
  private = [
    {
      cidr_block        = "10.0.4.0/24"
      availability_zone = "us-east-1c"
    },
    {
      cidr_block        = "10.0.5.0/24"
      availability_zone = "us-east-1d"
    },
    {
      cidr_block        = "10.0.6.0/24"
      availability_zone = "us-east-1e"
    },
    {
      cidr_block        = "10.0.7.0/24"
      availability_zone = "us-east-1f"
    },
    {
      cidr_block        = "10.0.8.0/24"
      availability_zone = "us-east-1f"
    }
  ]
}
gwlbe_subnet_cidrs                   = ["10.0.9.0/24", "10.0.10.0/24"] # CIDRs for GWLBE Subnets
gwlbe_subnet_azs                     = ["us-east-1a", "us-east-1b"] # If empty, GWLBE subnets will be created in all AZs
gwlbe_service_name                   = "gwlbe-name" # GWLBE service name
log_group_name                       = "VPC-Flowlog-Group" # Flow log group name
log_group_class                      = "STANDARD" # Make Sure it's in upper case, [STANDARD or INFREQUENT_ACCESS]
log_retention_days                   = 0          # 0 means never expire

# Provide format for VPC flowlog
flowlog_format                       = "$${version} $${account-id} $${interface-id} $${start} $${end} $${tcp-flags} $${action}"
flowlog_maximum_aggregation_interval = 60 # Flowlog maximum aggregation Interval - 60 OR 600 only

# Custom tags to be applied to all resources
tags = {
  Environment = "Test"
}

#IAM
flow_log_role_name               = "vpc_flowlog_role" # VPC Flowlog Role Name
aws_support_role_name            = "aws_support_role" # AWS Support role name
account_id                       = "XXXXXXXXXX" # ID of the Account in which the resources are being deployed
#role_name                       = "Name of the new Role created"