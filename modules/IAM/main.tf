resource "aws_iam_role" "flow_log_role" {
  name = var.flow_log_role_name

  assume_role_policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Principal": {
                "Service": "vpc-flow-logs.amazonaws.com"
            },
            "Action": "sts:AssumeRole"
        }
    ]
}
EOF
}

resource "aws_iam_role_policy" "vpc_flow_log_policy" {
  role   = aws_iam_role.flow_log_role.name
  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
                "logs:CreateLogGroup",
                "logs:CreateLogStream",
                "logs:PutLogEvents",
                "logs:DescribeLogGroups",
                "logs:DescribeLogStreams"
            ],
            "Resource": "*"
        }
    ]
}
EOF
}

# AWS Support Access Role for Access to AWS Support
resource "aws_iam_role" "aws_support_role" {
  name = var.aws_support_role_name

  assume_role_policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Principal": {
                "AWS": "arn:aws:iam::${var.account_id}:root"
            },
            "Action": "sts:AssumeRole",
            "Condition": {}
        }
    ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "aws_support_role_policy_attachment" {
  role       = aws_iam_role.aws_support_role.name
  policy_arn = "arn:aws:iam::aws:policy/AWSSupportAccess"
}

/* ADD Roles as per requirement
resource "aws_iam_role" "role_name" {
  name = var.role_name

  assume_role_policy = <<EOF
 
  EOF
}

resource "aws_iam_role_policy" "policy" {
  role   = aws_iam_role.role.name
  policy = <<EOF

EOF
}
*/