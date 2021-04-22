# CodeBuild
module "myapp-project" {

  source = "lgallard/codebuild/aws"

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

  # Secondary Sources (optional)
  codebuild_secondary_sources = [
    {
      type              = "GITHUB"
      location          = "https://github.com/myprofile/myproject-1.git"
      source_identifier = "my_awesome_project1"
    },
    {
      type                = "GITHUB"
      location            = "https://github.com/myprofile/myproject-2.git"
      git_clone_depth     = 1
      source_identifier   = "my_awesome_project2"
      report_build_status = true
      insecure_ssl        = true
    }
  ]

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
        value = "012345678910.dkr.ecr.us-west-1.amazonaws.com/my-ecr"
      },
      {
        name  = "AWS_DEFAULT_REGION"
        value = "us-west-1"
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
  bucket_prefix = "myapp-project-bucket-"
  acl           = "private"
}
