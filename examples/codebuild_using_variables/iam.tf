data "aws_iam_policy_document" "codebuild_policy_document" {
  statement {
    effect    = "Allow"
    resources = ["*"]
    actions = [
      "ecr:*",
    ]
  }

  statement {
    effect = "Allow"
    #resources = ["arn:aws:s3:::${aws_s3_bucket.myapp-project.bucket}/"]
    resources = ["*"]
    actions = [
      "ecr:*",
      "s3:PutObject",
      "s3:GetObject",
      "s3:DeleteObject"
    ]
  }
}

resource "aws_iam_role_policy" "codebuild_policy" {
  role   = module.myapp-project-var.service_role_name
  policy = data.aws_iam_policy_document.codebuild_policy_document.json
}
