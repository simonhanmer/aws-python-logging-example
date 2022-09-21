resource "aws_cloudwatch_log_group" "dumper_lambda_log_group" {
    name              = "/aws/lambda/${aws_lambda_function.event_dumper_lambda.function_name}"
    retention_in_days = var.log_group_retention
}