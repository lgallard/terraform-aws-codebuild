# Service role
resource "aws_iam_role" "service_role" {
  name               = "${var.name}-service-role"
  assume_role_policy = data.aws_iam_policy_document.codebuild_assume_role_policy.json

}

# Add extra polcies
resource "aws_iam_role_policy" "codebuild_role_extra_policies" {
  role   = aws_iam_role.service_role.name
  policy = data.aws_iam_policy_document.codebuild_role_extra_policies.json
}

####################
# Policy documents #
####################

# Assume Role
data "aws_iam_policy_document" "codebuild_assume_role_policy" {
  statement {
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["codebuild.amazonaws.com"]
    }

    actions = [
      "sts:AssumeRole",
    ]

  }
}

# Extra policies
data "aws_iam_policy_document" "codebuild_role_extra_policies" {
  statement {
    effect = "Allow"


    actions = [
      "logs:CreateLogGroup",
      "logs:CreateLogStream",
      "logs:PutLogEvents",
    ]

    resources = [
      "arn:aws:logs:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:log-group:/aws/codebuild/${var.name}",
      "arn:aws:logs:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:log-group:/aws/codebuild/${var.name}:*",
    ]
  }

  statement {
    effect = "Allow"


    actions = [
      "s3:GetObject",
      "s3:GetObjectVersion",
      "s3:PutObject",
    ]

    resources = [
      "arn:aws:s3:::codepipeline-${data.aws_region.current.name}-*",
    ]
  }

  statement {
    effect = "Allow"
    actions = [
      "ec2:CreateNetworkInterface",
      "ec2:DeleteNetworkInterface",
      "ec2:Describe*",
    ]
    resources = ["*"]
  }
  statement {
    effect = "Allow"
    actions = [
      "ec2:CreateNetworkInterfacePermission"
    ]
    resources = ["*"]
  }
}
