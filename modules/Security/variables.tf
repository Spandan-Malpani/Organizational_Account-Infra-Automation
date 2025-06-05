variable "password_policy" {
  description = "IAM Password Policy settings"
  type = object({
    minimum_password_length        = number
    require_lowercase_characters   = bool
    require_uppercase_characters   = bool
    require_numbers               = bool
    require_symbols               = bool
    allow_users_to_change_password = bool
    password_reuse_prevention     = number
    max_password_age             = number
    hard_expiry                  = bool
  })
}

variable "aws_region" {
  description = "AWS region for deploying resources"
  type        = string
}
