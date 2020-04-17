# CodeBuild
module "myapp-project" {

  source = "git::https://github.com/lgallard/terraform-aws-codebuild.git"

  name        = "my-app"
  description = "Codebuild for deploying myapp"

  # CodeBuild Source
  codebuild_source_version = "master"
  codebuild_source = {
    type            = "GITHUB"
    location        = "https://github.com/lgallard/codebuild-example.git"
    git_clone_depth = 1

    git_submodules_config = {
      fetch_submodules = true
    }
  }

  # Environment
  environment = {
    compute_type    = "BUILD_GENERAL1_SMALL"
    image           = "aws/codebuild/standard:2.0"
    type            = "LINUX_CONTAINER"
    privileged_mode = true

    # Environment variables
    variables = [
      {
        name  = "REGISTRY_URL"
        value = "012345678910.dkr.ecr.us-east-1.amazonaws.com/my-ecr"
      },
      {
        name  = "AWS_DEFAULT_REGION"
        value = "us-east-1"
      },
    ]
  }

  # Artifacts
  artifacts = {
    location  = aws_s3_bucket.myapp-project.bucket
    type      = "S3"
    path      = "/"
    packaging = "ZIP"
  }

  # Cache
  cache = {
    type     = "S3"
    location = aws_s3_bucket.myapp-project.bucket
  }

  # Logs
  s3_logs = {
    status   = "ENABLED"
    location = "${aws_s3_bucket.myapp-project.id}/build-log"
  }

  # Tags
  tags = {
    Environment = "dev"
    owner       = "development-team"
  }

}

# S3
resource "aws_s3_bucket" "myapp-project" {
  bucket = "myapp-project-bucket"
  acl    = "private"
}

