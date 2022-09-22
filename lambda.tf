data "archive_file" "lambda_function_zip" {
    type = "zip"
    source_file = "source/lambda/logging_lambda/lambda_function.py"
    output_path = "source/lambda/logging_lambda/lambda.zip"
}

resource "aws_lambda_function" "lambda_function" {
    function_name    = "function_${var.project_name}"
    role             = aws_iam_role.lambda_execution_role.arn
    description      = "Dump event received by lambda to cloudwatch logs"
    filename         = data.archive_file.lambda_function_zip.output_path
    source_code_hash = data.archive_file.lambda_function_zip.output_base64sha256
    handler          = "lambda_function.lambda_handler"
    runtime          = "python3.9"
    environment {
      variables = {
        LOG_LEVEL = "ERROR"
      }
    }
}
