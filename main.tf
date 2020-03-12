resource "aws_codebuild_project" "cb_project" {

  name           = var.name
  description    = var.description
  badge_enabled  = var.badge_enabled
  build_timeout  = var.build_timeout
  service_role   = aws_iam_role.service_role.arn
  queued_timeout = var.queued_timeout

  dynamic "artifacts" {
    for_each = [local.artifacts]
    content {
      type                   = lookup(artifacts.value, "type", var.artifacts_type)
      artifact_identifier    = lookup(artifacts.value, "artifact_identifier ", var.artifacts_artifact_identifier)
      encryption_disabled    = lookup(artifacts.value, "encryption_disabled", var.artifacts_type)
      override_artifact_name = lookup(artifacts.value, "override_artifact_name", var.artifacts_override_artifact_name)
      location               = lookup(artifacts.value, "location", var.artifacts_location)
      name                   = lookup(artifacts.value, "name", var.artifacts_name)
      namespace_type         = lookup(artifacts.value, "namespace_type", var.artifacts_namespace_type)
      packaging              = lookup(artifacts.value, "packaging", var.artifacts_packaging)
      path                   = lookup(artifacts.value, "path", var.artifacts_path)
    }
  }

}

locals {

}
