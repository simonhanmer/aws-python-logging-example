resource "aws_cloudwatch_metric_alarm" "cloudwatch_alarm" {
    alarm_name          = "${var.project_name} Alarm"
    comparison_operator = "GreaterThanOrEqualToThreshold"
    evaluation_periods  = "1"
    threshold           = "5"
    alarm_description   = "Lambda error rate has exceeded threshold"

    metric_query {
      id          = "m1"
      return_data = true

      metric {
        metric_name = aws_lambda_function.lambda_function.function_name
        namespace   = var.lambda_metric_namespace
        period      = 300
        stat        = "Sum"
        unit        = "Count"

        dimensions = {
            level = "Error"
        }
      }
    }
}