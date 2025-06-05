###############################
# 1. IAM Password Policy
###############################
resource "aws_iam_account_password_policy" "strict" {
  minimum_password_length        = var.password_policy.minimum_password_length
  require_lowercase_characters   = var.password_policy.require_lowercase_characters
  require_uppercase_characters   = var.password_policy.require_uppercase_characters
  require_numbers               = var.password_policy.require_numbers
  require_symbols               = var.password_policy.require_symbols
  allow_users_to_change_password = var.password_policy.allow_users_to_change_password
  password_reuse_prevention     = var.password_policy.password_reuse_prevention
  max_password_age             = var.password_policy.max_password_age
  hard_expiry                  = var.password_policy.hard_expiry
}

###############################
# 2. Security Hub Configuration
###############################
resource "aws_securityhub_account" "main" {
  enable_default_standards = false  # We'll explicitly enable the ones we want
}

resource "aws_securityhub_standards_subscription" "cis_3_0_0" {
  depends_on    = [aws_securityhub_account.main]
  standards_arn = "arn:aws:securityhub:${var.aws_region}::standards/cis-aws-foundations-benchmark/v/3.0.0"
}

resource "aws_securityhub_standards_subscription" "nist" {
  depends_on    = [aws_securityhub_account.main]
  standards_arn = "arn:aws:securityhub:${var.aws_region}::standards/nist-800-53/v/5.0.0"
}

resource "aws_securityhub_standards_subscription" "foundational_best_practices" {
  depends_on = [aws_securityhub_account.main]
  standards_arn = "arn:aws:securityhub:${var.aws_region}::standards/aws-foundational-security-best-practices/v/1.0.0"
}

# ENABLE IF NEEDED #
/*
resource "aws_securityhub_standards_subscription" "resource_tagging" {
  depends_on = [aws_securityhub_account.main]
  standards_arn = "arn:aws:securityhub:${var.aws_region}::standards/aws-resource-tagging-standard/v/1.0.0"
}
*/

/*
resource "aws_securityhub_standards_subscription" "cis_1_4_0" {
  depends_on = [aws_securityhub_account.main]
  standards_arn = "arn:aws:securityhub:${var.aws_region}::standards/cis-aws-foundations-benchmark/v/1.4.0"
}
*/

/*
resource "aws_securityhub_standards_subscription" "pci_dss_3_2_1" {
  depends_on    = [aws_securityhub_account.main]
  standards_arn = "arn:aws:securityhub:${var.aws_region}::standards/pci-dss/v/3.2.1"
}
*/

/* 
resource "aws_securityhub_standards_subscription" "pci_dss_4_0_1" {
  depends_on    = [aws_securityhub_account.main]
  standards_arn = "arn:aws:securityhub:${var.aws_region}::standards/pci-dss/v/4.0.1"
}
*/

###############################
# 3. GuardDuty Configuration
###############################
resource "aws_guardduty_detector" "main" {
  enable = true
  
  datasources {
    s3_logs {
      enable = true
    }
  }
}

###############################
# 4. S3 Account-Level Security
###############################
resource "aws_s3_account_public_access_block" "main" {
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

###############################
# 5. EBS Default Encryption
###############################
resource "aws_ebs_encryption_by_default" "main" {
  enabled = true
}
