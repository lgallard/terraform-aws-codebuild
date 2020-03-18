# Artifacts
variable "artifacts" {
  description = "Information about the project's build output artifacts."
  type        = map
}

variable "artifacts_type" {
  description = "The build output artifact's type. Valid values for this parameter are: `CODEPIPELINE`, `NO_ARTIFACTS` or `S3`."
  type        = string
  default     = "NO_ARTIFACTS"
}

variable "artifacts_artifact_identifier" {
  description = "The artifact identifier. Must be the same specified inside AWS CodeBuild buildspec."
  type        = string
  default     = null
}

variable "artifacts_encryption_disabled" {
  description = "If set to true, output artifacts will not be encrypted. If `type` is set to `NO_ARTIFACTS` then this value will be ignored."
  type        = bool
  default     = false
}

variable "artifacts_override_artifact_name" {
  description = "If set to true, a name specified in the build spec file overrides the artifact name."
  type        = bool
  default     = true
}

variable "artifacts_location" {
  description = "Information about the build output artifact location. If `type` is set to `CODEPIPELINE` or `NO_ARTIFACTS` then this value will be ignored. If `type` is set to `S3`, this is the name of the output bucket."
  type        = string
  default     = null
}

variable "artifacts_name" {
  description = "The name of the project. If `type` is set to `S3`, this is the name of the output artifact object."
  type        = string
  default     = null
}

variable "artifacts_namespace_type" {
  description = "The namespace to use in storing build artifacts. If `type` is set to `S3`, then valid values for this parameter are: `BUILD_ID` or `NONE`."
  type        = string
  default     = null
}

variable "artifacts_packaging" {
  description = "The type of build output artifact to create. If `type` is set to `S3`, valid values for this parameter are: `NONE` or `ZIP`"
  type        = string
  default     = null
}

variable "artifacts_path" {
  description = "If `type` is set to `S3`, this is the path to the output artifact"
  type        = string
  default     = ""
}

# Cache
variable "cache_type" {
  description = "The type of storage that will be used for the AWS CodeBuild project cache. Valid values: `NO_CACHE`, `LOCAL`, and `S3`."
  type        = string
  default     = "NO_CACHE"
}

variable "cache_location" {
  description = "The location where the AWS CodeBuild project stores cached resources. For type S3 the value must be a valid S3 bucket name/prefix. (Required when cache `type` is `S3`)"
  type        = string
  default     = null
}

variable "cache_modes" {
  description = "Specifies settings that AWS CodeBuild uses to store and reuse build dependencies. Valid values: `LOCAL_SOURCE_CACHE`, `LOCAL_DOCKER_LAYER_CACHE`, and `LOCAL_CUSTOM_CACHE`. (Required when cache type is `LOCAL`)"
  type        = string
  default     = []
}

# Environment
variable "environment" {
  description = "Information about the project's build environment."
  type        = map
}

variable "name" {
  description = "The projects name."
  type        = string
}

variable "source" {
  description = "Information about the project's input source code."
  type        = map
}

variable "badge_enabled" {
  description = "Generates a publicly-accessible URL for the projects build badge. Available as badge_url attribute when enabled."
  type        = bool
  default     = false
}

variable "build_timeout" {
  description = "How long in minutes, from 5 to 480 (8 hours), for AWS CodeBuild to wait until timing out any related build that does not get marked as completed.The default is 60 minutes."
  type        = number
  default     = 60
}

variable "queued_timeout" {
  description = "How long in minutes, from 5 to 480 (8 hours), a build is allowed to be queued before it times out.The default is 8 hours."
  type        = number
  default     = 480
}

variable "cache" {
  description = "Information about the cache storage for the project."
  type        = map
}

variable "description" {
  description = "A short description of the project."
  type        = string
  default     = null
}

variable "cloudwatch_logs" {
  description = "Configuration for the builds to store log data to CloudWatch."
  type        = map
  default     = null
}

variable "s3_logs" {
  description = "Configuration for the builds to store log data to S3."
  type        = map
  default     = null
}
