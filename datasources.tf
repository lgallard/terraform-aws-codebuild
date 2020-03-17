# Region
data "aws_region" "current" {}

# Account ID
data "aws_caller_identity" "current" {}
