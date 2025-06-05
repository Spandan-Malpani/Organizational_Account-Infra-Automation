#Cloudwatch log group for VPC flowlogs
resource "aws_cloudwatch_log_group" "vpc_flow_logs_group" {
  name              = var.log_group_name
  retention_in_days = 0 # Never expire
  log_group_class   = var.log_group_class

  tags = merge(var.tags, {
    Name = "${var.vpc_name}-flow-logs"
  })
}

resource "aws_vpc" "custom" {
  cidr_block           = var.vpc_cidr_block
  enable_dns_support   = var.enable_dns_support
  enable_dns_hostnames = var.enable_dns_hostnames

  tags = merge(var.tags, {
    Name = var.vpc_name
  })
}

resource "aws_internet_gateway" "main" {
  depends_on = [aws_vpc.custom]
  vpc_id     = aws_vpc.custom.id

  tags = merge(var.tags, {
    Name = "${var.vpc_name}-igw"
  })
}

# Public Subnets
resource "aws_subnet" "public_subnet" {
  count                   = length(var.subnet_configurations.public)
  vpc_id                  = aws_vpc.custom.id
  cidr_block              = var.subnet_configurations.public[count.index].cidr_block
  availability_zone       = var.subnet_configurations.public[count.index].availability_zone
  map_public_ip_on_launch = var.map_public_ip

  tags = merge(var.tags, {
    Name = "${var.vpc_name}-public-subnet-${count.index + 1}"
  })
}

# Private Subnets
resource "aws_subnet" "private_subnet" {
  count             = length(var.subnet_configurations.private)
  vpc_id            = aws_vpc.custom.id
  cidr_block        = var.subnet_configurations.private[count.index].cidr_block
  availability_zone = var.subnet_configurations.private[count.index].availability_zone

  tags = merge(var.tags, {
    Name = "${var.vpc_name}-private-subnet-${count.index + 1}"
  })
}

# GWLBE Subnets
# GWLBE Subnets
resource "aws_subnet" "gwlbe_subnet" {
  count             = length(var.gwlbe_subnet_azs)
  vpc_id            = aws_vpc.custom.id
  cidr_block        = var.gwlbe_subnet_cidrs[count.index]
  availability_zone = var.gwlbe_subnet_azs[count.index]

  tags = merge(var.tags, {
    Name = "${var.vpc_name}-gwlbe-subnet-${count.index + 1}"
  })
}

# Route Tables for Public Subnets
resource "aws_route_table" "public_rt" {
  count  = length(var.subnet_configurations.public)
  vpc_id = aws_vpc.custom.id

  tags = merge(var.tags, {
    Name = "${var.vpc_name}-public-rt-${count.index + 1}"
  })
}

# Route Tables for Private Subnets
resource "aws_route_table" "private_rt" {
  count  = length(var.subnet_configurations.private)
  vpc_id = aws_vpc.custom.id

  tags = merge(var.tags, {
    Name = "${var.vpc_name}-private-rt-${count.index + 1}"
  })
}

# Route Table Associations for subnets
resource "aws_route_table_association" "public" {
  count          = length(var.subnet_configurations.public)
  subnet_id      = aws_subnet.public_subnet[count.index].id
  route_table_id = aws_route_table.public_rt[count.index].id
}

resource "aws_route_table_association" "private" {
  count          = length(var.subnet_configurations.private)
  subnet_id      = aws_subnet.private_subnet[count.index].id
  route_table_id = aws_route_table.private_rt[count.index].id
}

resource "aws_route_table" "gwlb_ingress" {
  depends_on = [aws_vpc.custom]
  vpc_id     = aws_vpc.custom.id

  tags = merge(var.tags, {
    Name = "${var.vpc_name}-gwlb-ingress"
  })
}

resource "aws_route_table" "gwlbe_rt" {
  count  = length(var.gwlbe_subnet_azs)
  vpc_id = aws_vpc.custom.id

  tags = merge(var.tags, {
    Name = "${var.vpc_name}-gwlbe-rt-${count.index + 1}"
  })
}

# VPC Endpoints
resource "aws_vpc_endpoint" "gwlbe" {
  count             = length(var.gwlbe_subnet_azs)
  vpc_id            = aws_vpc.custom.id
  service_name      = var.gwlbe_service_name
  vpc_endpoint_type = "GatewayLoadBalancer"
  subnet_ids        = [aws_subnet.gwlbe_subnet[count.index].id]

  tags = merge(var.tags, {
    Name = "${var.vpc_name}-gwlbe-${count.index + 1}"
  })
}

resource "aws_route_table_association" "gwlbe_subnet" {
  count          = length(var.gwlbe_subnet_azs)
  subnet_id      = aws_subnet.gwlbe_subnet[count.index].id
  route_table_id = aws_route_table.gwlbe_rt[count.index].id
}

# Public Route Table to Gateway
resource "aws_route" "public_to_igw" {
  count          = length(var.subnet_configurations.public)
  route_table_id = aws_route_table.public_rt[count.index].id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.main.id
}

# Private Route Table to Gateway (or VPC Endpoint if necessary)
resource "aws_route" "private_to_gwlbe" {
  count          = length(var.gwlbe_subnet_azs)
  route_table_id = aws_route_table.private_rt[count.index].id
  destination_cidr_block = "0.0.0.0/0"
  vpc_endpoint_id        = aws_vpc_endpoint.gwlbe[count.index].id
}

# GWLBE Route Table to VPC Endpoint
resource "aws_route" "gwlbe_route" {
  count          = length(var.gwlbe_subnet_azs)
  route_table_id = aws_route_table.gwlbe_rt[count.index].id
  destination_cidr_block = "0.0.0.0/0"
  vpc_endpoint_id        = aws_vpc_endpoint.gwlbe[count.index].id
}

# VPC Flow Logs
resource "aws_flow_log" "vpc_flow_log" {
  depends_on = [
    aws_vpc.custom,
    aws_cloudwatch_log_group.vpc_flow_logs_group
  ]

  iam_role_arn             = var.flow_log_role_arn
  vpc_id                   = aws_vpc.custom.id
  traffic_type             = var.flow_log_traffic_type
  max_aggregation_interval = var.flowlog_maximum_aggregation_interval
  log_format               = var.flowlog_format
  log_destination          = aws_cloudwatch_log_group.vpc_flow_logs_group.arn

  tags = merge(var.tags, {
    Name = "${var.vpc_name}-flow-logs"
  })
}
