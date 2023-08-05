resource "aws_cloudwatch_log_group" "admin" {
  name              = "/${local.app_name}/admin"
  retention_in_days = 180
}

resource "aws_ssm_document" "admin" {
  name            = "${local.app_name}-admin"
  document_type   = "Session"
  document_format = "JSON"

  content = templatefile("template/admin_content.json", {
    cloud_watch_log_group_name: aws_cloudwatch_log_group.admin.name
  })
}
