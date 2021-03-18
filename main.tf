resource "aws_codebuild_project" "cb_project" {
  name           = var.name
  badge_enabled  = var.badge_enabled
  build_timeout  = var.build_timeout
  description    = var.description
  encryption_key = var.encryption_key
  service_role   = aws_iam_role.service_role.arn
  source_version = var.codebuild_source_version
  queued_timeout = var.queued_timeout

  # Artifacts
  dynamic "artifacts" {
    for_each = local.artifacts
    content {
      type                   = lookup(artifacts.value, "type")
      artifact_identifier    = lookup(artifacts.value, "artifact_identifier")
      encryption_disabled    = lookup(artifacts.value, "encryption_disabled")
      override_artifact_name = lookup(artifacts.value, "override_artifact_name")
      location               = lookup(artifacts.value, "location")
      name                   = lookup(artifacts.value, "name")
      namespace_type         = lookup(artifacts.value, "namespace_type")
      packaging              = lookup(artifacts.value, "packaging")
      path                   = lookup(artifacts.value, "path")
    }
  }

  # Cache
  dynamic "cache" {
    for_each = local.cache
    content {
      type     = lookup(cache.value, "type")
      location = lookup(cache.value, "location")
      modes    = lookup(cache.value, "modes")
    }
  }

  # Environment
  dynamic "environment" {
    for_each = local.environment
    content {
      compute_type                = lookup(environment.value, "compute_type")
      image                       = lookup(environment.value, "image")
      type                        = lookup(environment.value, "type")
      image_pull_credentials_type = lookup(environment.value, "image_pull_credentials_type")
      privileged_mode             = lookup(environment.value, "privileged_mode")
      certificate                 = lookup(environment.value, "certificate")

      # Registry Credential
      dynamic "registry_credential" {
        for_each = length(lookup(environment.value, "registry_credential")) == 0 ? [] : [lookup(environment.value, "registry_credential")]
        content {
          credential          = registry_credential.value.credential
          credential_provider = registry_credential.value.credential_provider
        }
      }

      # Environment variables
      dynamic "environment_variable" {
        for_each = length(lookup(environment.value, "variables")) == 0 ? [] : lookup(environment.value, "variables")
        content {
          name  = environment_variable.value.name
          value = environment_variable.value.value
          type  = lookup(environment_variable.value, "type", null) == null ? "PLAINTEXT" : environment_variable.value.type
        }
      }
    }
  }

  # Logs_config
  dynamic "logs_config" {
    for_each = local.logs_config
    content {

      # Cloudwatch_logs
      dynamic "cloudwatch_logs" {
        for_each = [lookup(logs_config.value, "cloudwatch_logs")]
        content {
          status      = cloudwatch_logs.value.status
          group_name  = cloudwatch_logs.value.group_name
          stream_name = cloudwatch_logs.value.stream_name
        }
      }

      # S3_logs
      dynamic "s3_logs" {
        for_each = [lookup(logs_config.value, "s3_logs")]
        content {
          status              = s3_logs.value.status
          location            = s3_logs.value.location
          encryption_disabled = s3_logs.value.encryption_disabled
        }
      }

    }
  }

  # Source
  dynamic "source" {
    for_each = local.source
    content {
      type                = lookup(source.value, "type")
      buildspec           = lookup(source.value, "buildspec")
      git_clone_depth     = lookup(source.value, "git_clone_depth")
      insecure_ssl        = lookup(source.value, "insecure_ssl")
      location            = lookup(source.value, "location")
      report_build_status = lookup(source.value, "report_build_status")

      # Auth
      dynamic "auth" {
        for_each = length(lookup(source.value, "auth")) == 0 ? [] : [lookup(source.value, "auth")]
        content {
          type     = auth.value.type
          resource = auth.value.resource
        }
      }

      # Git Submodules Config
      dynamic "git_submodules_config" {
        for_each = length(lookup(source.value, "git_submodules_config")) == 0 ? [] : [lookup(source.value, "git_submodules_config")]
        content {
          fetch_submodules = git_submodules_config.value.fetch_submodules
        }
      }

    }
  }

  # Secondary Sources
  dynamic "secondary_sources" {
    for_each = local.secondary_sources
    content {
      type                = lookup(secondary_sources.value, "type", "CODEBUILD")
      buildspec           = lookup(secondary_sources.value, "buildspec", null)
      git_clone_depth     = lookup(secondary_sources.value, "git_clone_depth", 0)
      insecure_ssl        = lookup(secondary_sources.value, "insecure_ssl", var.codebuild_source_insecure_ssl)
      location            = lookup(secondary_sources.value, "location", null)
      report_build_status = lookup(secondary_sources.value, "report_build_status", var.codebuild_source_report_build_status)
      source_identifier   = lookup(secondary_sources.value, "source_identifier", null)

      # Auth
      dynamic "auth" {
        for_each = length(lookup(secondary_sources.value, "auth")) == 0 ? [] : [lookup(secondary_sources.value, "auth")]
        content {
          type     = auth.value.type
          resource = auth.value.resource
        }
      }

      # Git Submodules Config
      dynamic "git_submodules_config" {
        for_each = length(lookup(secondary_sources.value, "git_submodules_config")) == 0 ? [] : [lookup(secondary_sources.value, "git_submodules_config")]
        content {
          fetch_submodules = git_submodules_config.value.fetch_submodules
        }
      }
    }
  }

  # VPC Config
  dynamic "vpc_config" {
    for_each = lookup(local.vpc_config, "vpc_id") == null ? [] : [local.vpc_config]
    content {
      vpc_id             = lookup(vpc_config.value, "vpc_id")
      subnets            = lookup(vpc_config.value, "subnets")
      security_group_ids = lookup(vpc_config.value, "security_group_ids")
    }
  }

  # Tags
  tags = var.tags

}

locals {

  # Artifacts
  # If no artifacts block is provided, build one using the default values
  artifacts = [
    {
      type                   = lookup(var.artifacts, "type", null) == null ? var.artifacts_type : lookup(var.artifacts, "type")
      artifact_identifier    = lookup(var.artifacts, "artifact_identifier", null) == null ? var.artifacts_artifact_identifier : lookup(var.artifacts, "artifact_identifier")
      encryption_disabled    = lookup(var.artifacts, "encryption_disabled", null) == null ? var.artifacts_encryption_disabled : lookup(var.artifacts, "encryption_disabled")
      override_artifact_name = lookup(var.artifacts, "override_artifact_name", null) == null ? var.artifacts_override_artifact_name : lookup(var.artifacts, "override_artifact_name")
      location               = lookup(var.artifacts, "location", null) == null ? var.artifacts_location : lookup(var.artifacts, "location")
      name                   = lookup(var.artifacts, "name", null) == null ? var.artifacts_name : lookup(var.artifacts, "name")
      namespace_type         = lookup(var.artifacts, "namespace_type", null) == null ? var.artifacts_namespace_type : lookup(var.artifacts, "namespace_type")
      packaging              = lookup(var.artifacts, "packaging", null) == null ? var.artifacts_packaging : lookup(var.artifacts, "packaging")
      path                   = lookup(var.artifacts, "path", null) == null ? var.artifacts_path : lookup(var.artifacts, "path")
    }
  ]

  # Cache
  # If no cache block is provided, build one using the default values
  cache = [
    {
      type     = lookup(var.cache, "type", null) == null ? var.cache_type : lookup(var.cache, "type")
      location = lookup(var.cache, "location", null) == null ? var.cache_location : lookup(var.cache, "location")
      modes    = lookup(var.cache, "modes", null) == null ? var.cache_modes : lookup(var.cache, "modes")
    }
  ]

  # Environment
  # If no environment block is provided, build one using the default values
  environment = [
    {
      compute_type                = lookup(var.environment, "compute_type", null) == null ? var.environment_compute_type : lookup(var.environment, "compute_type")
      image                       = lookup(var.environment, "image", null) == null ? var.environment_image : lookup(var.environment, "image")
      type                        = lookup(var.environment, "type", null) == null ? var.environment_type : lookup(var.environment, "type")
      image_pull_credentials_type = lookup(var.environment, "image_pull_credentials_type", null) == null ? var.environment_image_pull_credentials_type : lookup(var.environment, "image_pull_credentials_type")
      variables                   = lookup(var.environment, "variables", null) == null ? var.environment_variables : lookup(var.environment, "variables")
      privileged_mode             = lookup(var.environment, "privileged_mode", null) == null ? var.environment_privileged_mode : lookup(var.environment, "privileged_mode")
      certificate                 = lookup(var.environment, "certificate ", null) == null ? var.environment_certificate : lookup(var.environment, "certificate")
      registry_credential         = lookup(var.environment, "registry_credential", null) == null ? var.environment_registry_credential : lookup(var.environment, "registry_credential")
    }
  ]

  # CloudWatch logs
  cloudwatch_logs = {
    status      = lookup(var.cloudwatch_logs, "status", null) == null ? var.cloudwatch_logs_status : lookup(var.cloudwatch_logs, "status")
    group_name  = lookup(var.cloudwatch_logs, "group_name", null) == null ? var.cloudwatch_logs_group_name : lookup(var.cloudwatch_logs, "group_name")
    stream_name = lookup(var.cloudwatch_logs, "stream_name", null) == null ? var.cloudwatch_logs_stream_name : lookup(var.cloudwatch_logs, "stream_name")
  }


  # S3 logs
  s3_logs = {
    status              = lookup(var.s3_logs, "status", null) == null ? var.s3_logs_status : lookup(var.s3_logs, "status")
    location            = lookup(var.s3_logs, "location", null) == null ? var.s3_logs_location : lookup(var.s3_logs, "location")
    encryption_disabled = lookup(var.s3_logs, "encryption_disabled", null) == null ? var.s3_logs_encryption_disabled : lookup(var.s3_logs, "encryption_disabled")
  }

  # Logs_config
  # If no logs_config block is provided, build one using the default values
  logs_config = ((local.cloudwatch_logs == null && local.s3_logs == null) || (length(local.cloudwatch_logs) == 0 && length(local.s3_logs) == 0)) == true ? [] : [
    {
      cloudwatch_logs = local.cloudwatch_logs
      s3_logs         = local.s3_logs
    }
  ]

  # Source
  # If no source block is provided, build one using the default values
  source = [
    {
      type                  = lookup(var.codebuild_source, "type", null) == null ? var.codebuild_source_type : lookup(var.codebuild_source, "type")
      buildspec             = lookup(var.codebuild_source, "buildspec", null) == null ? var.codebuild_source_buildspec : lookup(var.codebuild_source, "buildspec")
      git_clone_depth       = lookup(var.codebuild_source, "git_clone_depth", null) == null ? var.codebuild_source_git_clone_depth : lookup(var.codebuild_source, "git_clone_depth")
      insecure_ssl          = lookup(var.codebuild_source, "insecure_ssl", null) == null ? var.codebuild_source_insecure_ssl : lookup(var.codebuild_source, "insecure_ssl")
      location              = lookup(var.codebuild_source, "location", null) == null ? var.codebuild_source_location : lookup(var.codebuild_source, "location")
      report_build_status   = lookup(var.codebuild_source, "report_build_status", null) == null ? var.codebuild_source_report_build_status : lookup(var.codebuild_source, "report_build_status")
      auth                  = lookup(var.codebuild_source, "auth", null) == null ? var.codebuild_source_auth : lookup(var.codebuild_source, "auth")
      git_submodules_config = lookup(var.codebuild_source, "git_submodules_config", null) == null ? var.codebuild_source_git_submodules_config : lookup(var.codebuild_source, "git_submodules_config")
    }
  ]

  secondary_sources = [
    for source in var.codebuild_secondary_sources :
    {
      type                  = lookup(source, "type", null) == null ? var.codebuild_secondary_source_type : lookup(source, "type")
      buildspec             = lookup(source, "buildspec", null) == null ? var.codebuild_secondary_source_buildspec : lookup(source, "buildspec")
      git_clone_depth       = lookup(source, "git_clone_depth", null) == null ? var.codebuild_secondary_source_git_clone_depth : lookup(source, "git_clone_depth")
      insecure_ssl          = lookup(source, "insecure_ssl", null) == null ? var.codebuild_secondary_source_insecure_ssl : lookup(source, "insecure_ssl")
      location              = lookup(source, "location", null) == null ? var.codebuild_secondary_source_location : lookup(source, "location")
      report_build_status   = lookup(source, "report_build_status", null) == null ? var.codebuild_secondary_source_report_build_status : lookup(source, "report_build_status")
      source_identifier     = lookup(source, "source_identifier", null) == null ? var.codebuild_secondary_source_identifier : lookup(source, "source_identifier")
      auth                  = lookup(source, "auth", null) == null ? var.codebuild_secondary_source_auth : lookup(source, "auth")
      git_submodules_config = lookup(source, "git_submodules_config", null) == null ? var.codebuild_secondary_source_git_submodules_config : lookup(source, "git_submodules_config")
    }
  ]


  # VPC Config
  # If no VPC Config block is provided, build one using the default values
  vpc_config = {
    vpc_id             = lookup(var.vpc_config, "vpc_id", null) == null ? var.vpc_config_vpc_id : lookup(var.vpc_config, "vpc_id")
    subnets            = lookup(var.vpc_config, "subnets", null) == null ? var.vpc_config_subnets : lookup(var.vpc_config, "subnets")
    security_group_ids = lookup(var.vpc_config, "security_group_ids", null) == null ? var.vpc_config_security_group_ids : lookup(var.vpc_config, "security_group_ids")
  }

}
