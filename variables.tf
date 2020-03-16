variable "artifacts" {
  description = "Information about the project's build output artifacts."
  type        = map
}

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
