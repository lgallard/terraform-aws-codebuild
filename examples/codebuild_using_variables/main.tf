# CodeBuild
module "myapp-project-var" {

  source = "lgallard/codebuild/aws"

  name        = "my-app-var"
  description = "Codebuild for deploying myapp (variables)"

  # CodeBuild Source
  codebuild_source_version = "master"

  codebuild_source_type                                   = "GITHUB"
  codebuild_source_location                               = "https://github.com/lgallard/codebuild-example.git"
  codebuild_source_git_clone_depth                        = 1
  codebuild_source_git_submodules_config_fetch_submodules = true

  # Environment
  environment_compute_type    = "BUILD_GENERAL1_SMALL"
  environment_image           = "aws/codebuild/standard:2.0"
  environment_type            = "LINUX_CONTAINER"
  environment_privileged_mode = true

  # Environment variables
  environment_variables = [
    {
      name  = "REGISTRY_URL"
      value = "012345678910.dkr.ecr.us-west-1.amazonaws.com/my-ecr"
    },
    {
      name  = "AWS_DEFAULT_REGION"
      value = "us-west-1"
    },
  ]

  # Artifacts
  artifacts_location  = aws_s3_bucket.myapp-project.bucket
  artifacts_type      = "S3"
  artifacts_path      = "/"
  artifacts_packaging = "ZIP"

  # Cache
  cache_type     = "S3"
  cache_location = aws_s3_bucket.myapp-project.bucket

  # Logs
  s3_logs_status   = "ENABLED"
  s3_logs_location = "${aws_s3_bucket.myapp-project.id}/build-var-log"


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
