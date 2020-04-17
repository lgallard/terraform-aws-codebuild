resource "aws_iam_role_policy" "codebuild_policy" {
  role   = module.myapp-project.service_role_name
  policy = data.aws_iam_policy_document.codebuild_policy_document.json
}

data "aws_iam_policy_document" "codebuild_policy_document" {

  statement {
    effect    = "Allow"
    resources = ["*"]
    actions = [
      "ecr:*",
    ]
  }

  statement {
    effect    = "Allow"
    resources = ["*"]
    actions = [
      "ecr:*",
      "s3:PutObject",
      "s3:GetObject",
      "s3:DeleteObject"
    ]
  }
}
