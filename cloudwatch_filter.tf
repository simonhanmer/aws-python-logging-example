locals {
  metric_levels = [ "ERROR", "CRITICAL" ]
}

resource "aws_cloudwatch_log_metric_filter" "log_group_filter" {
    for_each = toset(local.metric_levels)

    name           = "${aws_lambda_function.lambda_function.function_name}-${each.value}-filter"
    pattern        = format("[level=%s, timestamp]", each.value)
    log_group_name = aws_cloudwatch_log_group.lambda_log_group.name

    metric_transformation {
      name       = aws_lambda_function.lambda_function.function_name
      namespace  = var.lambda_metric_namespace
      dimensions = {
        level = "$level"
      }
      value = "1"
      unit = "Count"
    }
}
