![Terraform](https://lgallardo.com/images/terraform.jpg)
# terraform-aws-codebuild
Terraform module for creating [AWS CodeBuild](https://aws.amazon.com/codebuild/) Projects. AWS CodeBuild is a fully managed continuous integration service that compiles source code, runs tests, and produces software packages that are ready to deploy.

## Usage
You can  define CodeBuild projects using object variables (made of maps, lists, booleans, etc.), or you can define projects using the classic module's variables approach (eg. `artifacts_*`, `cache_*`, etc.).

In the [examples](examples/) folder you can check both approaches in detail and another example with VPC support.


## Example using objects
```
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
```

## Example using variables
```
module "myapp-project" {

  source = "git::https://github.com/lgallard/terraform-aws-codebuild.git"

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
      value = "012345678910.dkr.ecr.us-east-1.amazonaws.com/my-ecr"
    },
    {
      name  = "AWS_DEFAULT_REGION"
      value = "us-east-1"
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
```

## Providers

| Name | Version |
|------|---------|
| aws | n/a |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| artifacts | Information about the project's build output artifacts. | `any` | `{}` | no |
| artifacts\_artifact\_identifier | The artifact identifier. Must be the same specified inside AWS CodeBuild buildspec. | `string` | n/a | yes |
| artifacts\_encryption\_disabled | If set to true, output artifacts will not be encrypted. If `type` is set to `NO_ARTIFACTS` then this value will be ignored. | `bool` | `false` | no |
| artifacts\_location | Information about the build output artifact location. If `type` is set to `CODEPIPELINE` or `NO_ARTIFACTS` then this value will be ignored. If `type` is set to `S3`, this is the name of the output bucket. | `string` | n/a | yes |
| artifacts\_name | The name of the project. If `type` is set to `S3`, this is the name of the output artifact object. | `string` | n/a | yes |
| artifacts\_namespace\_type | The namespace to use in storing build artifacts. If `type` is set to `S3`, then valid values for this parameter are: `BUILD_ID` or `NONE`. | `string` | n/a | yes |
| artifacts\_override\_artifact\_name | If set to true, a name specified in the build spec file overrides the artifact name. | `bool` | `false` | no |
| artifacts\_packaging | The type of build output artifact to create. If `type` is set to `S3`, valid values for this parameter are: `NONE` or `ZIP` | `string` | n/a | yes |
| artifacts\_path | If `type` is set to `S3`, this is the path to the output artifact | `string` | `""` | no |
| artifacts\_type | The build output artifact's type. Valid values for this parameter are: `CODEPIPELINE`, `NO_ARTIFACTS` or `S3`. | `string` | `"CODEPIPELINE"` | no |
| badge\_enabled | Generates a publicly-accessible URL for the projects build badge. Available as badge\_url attribute when enabled. | `bool` | `false` | no |
| build\_timeout | How long in minutes, from 5 to 480 (8 hours), for AWS CodeBuild to wait until timing out any related build that does not get marked as completed.The default is 60 minutes. | `number` | `60` | no |
| cache | Information about the cache storage for the project. | `any` | `{}` | no |
| cache\_location | The location where the AWS CodeBuild project stores cached resources. For type S3 the value must be a valid S3 bucket name/prefix. (Required when cache `type` is `S3`) | `string` | n/a | yes |
| cache\_modes | Specifies settings that AWS CodeBuild uses to store and reuse build dependencies. Valid values: `LOCAL_SOURCE_CACHE`, `LOCAL_DOCKER_LAYER_CACHE`, and `LOCAL_CUSTOM_CACHE`. (Required when cache type is `LOCAL`) | `list` | `[]` | no |
| cache\_type | The type of storage that will be used for the AWS CodeBuild project cache. Valid values: `NO_CACHE`, `LOCAL`, and `S3`. | `string` | `"NO_CACHE"` | no |
| cloudwatch\_logs | Configuration for the builds to store log data to CloudWatch. | `any` | `{}` | no |
| cloudwatch\_logs\_group\_name | The group name of the logs in CloudWatch Logs. | `string` | n/a | yes |
| cloudwatch\_logs\_status | Current status of logs in CloudWatch Logs for a build project. Valid values: `ENABLED`, `DISABLED.` | `string` | `"ENABLED"` | no |
| cloudwatch\_logs\_stream\_name | The stream name of the logs in CloudWatch Logs. | `string` | n/a | yes |
| codebuild\_source | Information about the project's input source code. | `any` | `{}` | no |
| codebuild\_source\_auth | Information about the authorization settings for AWS CodeBuild to access the source code to be built. | `map` | `{}` | no |
| codebuild\_source\_auth\_resource | The resource value that applies to the specified authorization type. | `string` | n/a | yes |
| codebuild\_source\_auth\_type | The authorization type to use. The only valid value is OAUTH | `string` | `"OAUTH"` | no |
| codebuild\_source\_buildspec | The build spec declaration to use for this build project's related builds. This must be set when type is iNO\_SOURCE | `string` | n/a | yes |
| codebuild\_source\_git\_clone\_depth | Information about the Git submodules configuration for an AWS CodeBuild build project. Git submodules config blocks are documented below. This option is only valid when the type is `CODECOMMIT`. | `number` | `0` | no |
| codebuild\_source\_git\_submodules\_config | Information about the Git submodules configuration for an AWS CodeBuild build project. Git submodules config blocks are documented below. This option is only valid when the type is `CODECOMMIT`. | `map` | `{}` | no |
| codebuild\_source\_git\_submodules\_config\_fetch\_submodules | If set to true, fetches Git submodules for the AWS CodeBuild build project. | `bool` | `true` | no |
| codebuild\_source\_insecure\_ssl | Ignore SSL warnings when connecting to source control. | `bool` | `false` | no |
| codebuild\_source\_location | The location of the source code from git or s3. | `string` | n/a | yes |
| codebuild\_source\_report\_build\_status | Set to true to report the status of a build's start and finish to your source provider. This option is only valid when the type is `BITBUCKET` or `GITHUB`. | `bool` | `false` | no |
| codebuild\_source\_type | The type of repository that contains the source code to be built. Valid values for this parameter are: `CODECOMMIT`, `CODEPIPELINE`, `GITHUB`, `GITHUB_ENTERPRISE`, `BITBUCKET`, `S3` or `NO_SOURCE`. | `string` | `"CODEPIPELINE"` | no |
| codebuild\_source\_version | A version of the build input to be built for this project. If not specified, the latest version is used. | `string` | n/a | yes |
| description | A short description of the project. | `string` | n/a | yes |
| encryption\_key | The AWS Key Management Service (AWS KMS) customer master key (CMK) to be used for encrypting the build project's build output artifacts. | `string` | n/a | yes |
| environment | Information about the project's build environment. | `any` | `{}` | no |
| environment\_certificate | The ARN of the S3 bucket, path prefix and object key that contains the PEM-encoded certificate. | `string` | n/a | yes |
| environment\_compute\_type | Information about the compute resources the build project will use. Available values for this parameter are: `BUILD_GENERAL1_SMALL`, `BUILD_GENERAL1_MEDIUM`, `BUILD_GENERAL1_LARGE` or `BUILD_GENERAL1_2XLARGE`. `BUILD_GENERAL1_SMALL` is only valid if type is set to `LINUX_CONTAINER`. When type is set to `LINUX_GPU_CONTAINER`, compute\_type need to be `BUILD_GENERAL1_LARGE`. | `string` | `"BUILD_GENERAL1_MEDIUM"` | no |
| environment\_image | The Docker image to use for this build project. Valid values include Docker images provided by CodeBuild (e.g `aws/codebuild/standard:2.0`), Docker Hub images (e.g. `hashicorp/terraform:latest`), and full Docker repository URIs such as those for ECR (e.g. `137112412989.dkr.ecr.us-west-2.amazonaws.com/amazonlinux:latest`) | `string` | `"aws/codebuild/standard:2.0"` | no |
| environment\_image\_pull\_credentials\_type | The type of credentials AWS CodeBuild uses to pull images in your build. Available values for this parameter are `CODEBUID` or `SERVICE_ROLE`. When you use a cross-account or private registry image, you must use SERVICE\_ROLE credentials. When you use an AWS CodeBuild curated image, you must use CODEBUILD credentials. | `string` | `"CODEBUILD"` | no |
| environment\_privileged\_mode | If set to true, enables running the Docker daemon inside a Docker container. | `bool` | `false` | no |
| environment\_registry\_credential | Information about credentials for access to a private Docker registry. Registry Credential config blocks are documented below. | `map` | `{}` | no |
| environment\_type | The type of build environment to use for related builds. Available values are: `LINUX_CONTAINER`, `LINUX_GPU_CONTAINER`, `WINDOWS_CONTAINER` or `ARM_CONTAINER`. | `string` | `"LINUX_CONTAINER"` | no |
| environment\_variables | A list of sets of environment variables to make available to builds for this build project. | `list` | `[]` | no |
| name | The projects name. | `string` | n/a | yes |
| queued\_timeout | How long in minutes, from 5 to 480 (8 hours), a build is allowed to be queued before it times out.The default is 8 hours. | `number` | `480` | no |
| s3\_logs | Configuration for the builds to store log data to S3. | `any` | `{}` | no |
| s3\_logs\_encryption\_disabled | Set to true if you do not want S3 logs encrypted. | `string` | `true` | no |
| s3\_logs\_location | The name of the S3 bucket and the path prefix for S3 logs. Must be set if status is ENABLED, otherwise it must be empty. | `string` | n/a | yes |
| s3\_logs\_status | Current status of logs in S3 for a build project. Valid values: `ENABLED`, `DISABLED.` | `string` | `"DISABLED"` | no |
| tags | A mapping of tags to assign to the resource. | `map(string)` | `{}` | no |
| vpc\_config | Configuration for the builds to run inside a VPC. | `any` | `{}` | no |
| vpc\_config\_security\_group\_ids | The security group IDs to assign to running builds. | `list(string)` | `[]` | no |
| vpc\_config\_subnets | The subnet IDs within which to run builds. | `list(string)` | `[]` | no |
| vpc\_config\_vpc\_id | The ID of the VPC within which to run builds. | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| arn | The ARN of the CodeBuild project |
| id | The name (if imported via name) or ARN (if created via Terraform or imported via ARN) of the CodeBuild project. |
| name | The name of the CodeBuild project |
| service\_role\_arn | Amazon Resource Name (ARN) of the Service Role for CodeBuild. |
| service\_role\_id | ID of the Service Role created for CodeBuild. |
| service\_role\_name | Name of the Service Role created for CodeBuild. |
