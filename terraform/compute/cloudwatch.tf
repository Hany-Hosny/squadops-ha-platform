# CloudWatch Log Group for App Tier
resource "aws_cloudwatch_log_group" "app" {
  name              = "/app/compute"
  retention_in_days = 7
}
