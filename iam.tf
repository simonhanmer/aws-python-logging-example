resource "aws_iam_policy" "lambda_logging_policy" {
    name        = "policy_${var.project_name}"
    path        = "/"
    description = "IAM policy for logging from a lambda"

    policy = jsonencode({
        Version   = "2012-10-17"
        Statement = [
            {
                Action = [
                    "logs:CreateLogGroup",
                    "logs:CreateLogStream",
                    "logs:PutLogEvents"
                ],
                Effect = "Allow"
                Sid    = "LambdaLogging"
                Resource = "arn:aws:logs:*:*:*"
            }
        ]
    })
}

resource "aws_iam_role" "lambda_execution_role" {
  name = "role_${var.project_name}"

  assume_role_policy = jsonencode({
    Version   = "2012-10-17"
    Statement = [
      {
        Action    = "sts:AssumeRole"
        Effect    = "Allow"
        Sid       = ""
        Principal = {
          Service = "lambda.amazonaws.com"
        }
      },
    ]
  })

  inline_policy {
    name = "policy_${var.project_name}"
    policy = jsonencode({
      Version   = "2012-10-17"
      Statement = [
        {
          Sid      = "ListS3Buckets"
          Action   = "s3:ListAllMyBuckets"
          Effect   = "Allow"
          Resource = [
            "arn:aws:s3:::*"
          ]
        }
      ]      
    })
  }
}

resource "aws_iam_role_policy_attachment" "lambda_role_policy_attachment" {
  role       = aws_iam_role.lambda_execution_role.name
  policy_arn = aws_iam_policy.lambda_logging_policy.arn
}