# terraform-aws-codebuild

## Usage

```

module "myapp-project" {
  source = "../modules/terraform-aws-codebuild"

  name        = "my-app"
  description = "Codebuild for deploying myapp"

  source = {
    type = "GITHUB"
    location = "https://myaccount@github.com/myorg/myapp.git"
    version = "master"
    # The below line (or block) should be added by the module
    #auth_resource = "GITHUB" 

    # The below line should be added by the module (only valid when type is `BITBUCKET` or `GITHUB`
    #auth_resource = "GITHUB" 
    report_build_status = "true"
  }


  environment = {
    compute_type = "BUILD_GENERAL1_SMALL"
    image           = "aws/codebuild/standard:2.0"
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

 
  # Logs
  cloudwatch_logs {
    group_name = "log-group"
    stream_name = "log-stream"
  }

  s3_logs {
    status = "ENABLED"
    location = "${aws_s3_bucket.example.id}/build-log"
  } 

```
