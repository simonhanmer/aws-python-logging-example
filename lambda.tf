data "archive_file" "event_dumper_lambda_function_zip" {
    type = "zip"
    source_file = "source/lambda/eventDumper/lambda_function.py"
    output_path = "source/lambda/eventDumper/event_dumper_lambda.zip"
}

resource "aws_lambda_function" "event_dumper_lambda" {
    function_name    = "event-dumper-function"
    role             = aws_iam_role.event_dumper_lambda_role.arn
    description      = "Dump event received by lambda to cloudwatch logs"
    filename         = data.archive_file.event_dumper_lambda_function_zip.output_path
    source_code_hash = data.archive_file.event_dumper_lambda_function_zip.output_base64sha256
    handler          = "lambda_function.lambda_handler"
    runtime          = "python3.9"
    environment {
      variables = {
        LOG_LEVEL = "ERROR"
      }
    }
}