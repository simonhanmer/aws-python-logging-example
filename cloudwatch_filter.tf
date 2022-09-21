locals {
  metric_levels = [ "ERROR", "CRITICAL" ]
}

resource "aws_cloudwatch_log_metric_filter" "event-dumper-function-filters" {
    for_each = toset(local.metric_levels)

    name           = "${aws_lambda_function.event_dumper_lambda.function_name}-${each.value}-filter"
    pattern        = format("[level=%s, timestamp]", each.value)
    log_group_name = aws_cloudwatch_log_group.dumper_lambda_log_group.name

    metric_transformation {
      name       = aws_lambda_function.event_dumper_lambda.function_name
      namespace  = "lambdaEvents"
      dimensions = {
        level = "$level"
      }
      value = "1"
      unit = "Count"
    }
}