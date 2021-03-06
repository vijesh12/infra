resource "aws_cloudwatch_log_group" "processing" {
  name = "/aws/lambda/${var.environment}-csv-processor"
  retention_in_days = 7

  tags = {
    Environment = var.environment
  }
}