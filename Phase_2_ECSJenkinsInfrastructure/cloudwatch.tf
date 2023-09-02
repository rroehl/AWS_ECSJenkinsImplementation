/* resource "aws_kms_key" "cloudwatch" {
  description  = "KMS for cloudwatch log group"
  policy  = data.aws_iam_policy_document.cloudwatch.json
}*/

resource "aws_cloudwatch_log_group" jenkins_controller_log_group {
    name              = var.name_prefix
    retention_in_days = var.jenkins_controller_task_log_retention_days
   // kms_key_id        = aws_kms_key.cloudwatch.arn
    //tags              = var.tags
    }