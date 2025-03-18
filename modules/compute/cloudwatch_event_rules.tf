# CloudWatch Event Rule to trigger SFTP to S3 Lambda every minute 
resource "aws_cloudwatch_event_rule" "sftp_to_s3_rule" {
  name                = "sftp-to-s3-rule"
  description         = "Trigger SFTP to S3 Lambda fxn every minute"
  schedule_expression = "rate(1 minute)"
}

# Explicitly create a log group for the 'S3 to SFTP' Lambda function
# resource "aws_cloudwatch_log_group" "s3_to_sftp_lambda_log_group" {
#   name = "/aws/lambda/s3-to-sftp-lambda"
#   retention_in_days = 14
# }

resource "aws_cloudwatch_event_target" "sftp_to_s3_target" {
  rule      = aws_cloudwatch_event_rule.sftp_to_s3_rule.name
  target_id = "sftpToS3Lambda"
  arn       = aws_lambda_function.sftp_to_s3_lambda.arn
}

resource "aws_lambda_permission" "allow_cloudwatch_to_trigger_sftp_to_s3" {
  statement_id  = "AllowExecutionFromCloudWatch"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.sftp_to_s3_lambda.function_name
  principal     = "events.amazonaws.com"
  source_arn    = aws_cloudwatch_event_rule.sftp_to_s3_rule.arn
}

# S3 Bucket Notification to Trigger S3 to SFTP Lambda Function
resource "aws_s3_bucket_notification" "s3_to_sftp_notification" {
  bucket = var.s3_bucket_id

  lambda_function {
    lambda_function_arn = aws_lambda_function.s3_to_sftp_lambda.arn
    events              = ["s3:ObjectCreated:*"] # Trigger the Lambder function on any object creation in the s3 bucket
  }

  depends_on = [aws_lambda_permission.allow_s3_to_trigger_s3_to_sftp]
}

resource "aws_lambda_permission" "allow_s3_to_trigger_s3_to_sftp" {
  statement_id   = "AllowExecutionFromS3"
  action         = "lambda:InvokeFunction"
  function_name  = aws_lambda_function.s3_to_sftp_lambda.function_name
  principal      = "s3.amazonaws.com"
  source_arn     = var.s3_bucket_arn
  # source_account = var.account_id
}

# data "aws_caller_identity" "current" {}