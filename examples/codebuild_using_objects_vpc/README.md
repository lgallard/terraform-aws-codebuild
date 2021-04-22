# terraform-aws-codebuild (VPC example)
This example shows how to use this module to build a "Hello World" node.js docker image on a VPC, to push it to an ECR registry

```
# CodeBuild
module "myapp-project-vpc" {

  source = "lgallard/codebuild/aws"

  name        = "my-app-vpc"
  description = "Codebuild for deploying myapp in a VPC"

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

  artifacts = {
    location  = aws_s3_bucket.myapp-project.bucket
    type      = "S3"
    path      = "/"
    packaging = "ZIP"
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


  # VPC
  vpc_config = {
    vpc_id             = "vpc-123446789101"
    subnets            = ["subnet-7a1dc5a54444", "subnet-6b4a45b64444"]
    security_group_ids = ["sg-b475b46c4444", "sg-58b61a4c4444"]

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
```
