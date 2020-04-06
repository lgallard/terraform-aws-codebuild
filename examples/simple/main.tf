# CodeBuild
module "myapp-project" {
  source = "../terraform-aws-codebuild"

  name        = "my-app"
  description = "Codebuild for deploying myapp"

  codebuild_source_version = "master"
  codebuild_source = {
    type            = "GITHUB"
    location        = "https://github.com/mitchellh/packer.git"
    git_clone_depth = 1

    git_submodules_config = {
      fetch_submodules = true
    }
  }

  environment = {
    compute_type    = "BUILD_GENERAL1_SMALL"
    image           = "aws/codebuild/standard:2.0"
    type            = "LINUX_CONTAINER"
    privileged_mode = true

    # Environment variables
    variables = [
      {
        name  = "KEY1"
        value = "VALUE1"
      },
      {
        name  = "KEY2"
        value = "VALUE2"
      },
    ]
  }

  artifacts = {
    type = "NO_ARTIFACTS"
  }

  cache = {
    type     = "S3"
    location = aws_s3_bucket.myapp-project.bucket
  }

  # Logs
  s3_logs = {
    status   = "ENABLED"
    location = "${aws_s3_bucket.myapp-project.id}/build-log"
  }


  tags = {
    Environment = "dev"
    owner       = "lgallard"
  }

}

# S3
resource "aws_s3_bucket" "myapp-project" {
  bucket = "myapp-project-bucket"
  acl    = "private"
}

