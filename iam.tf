resource "aws_iam_policy" "lambda_logging" {
    name        = "lambda_logging"
    path        = "/"
    description = "IAM policy for logging from a lambda"

    policy = jsonencode({
        Version = "2012-10-17"
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
            },
            {
                Action = [
                    "s3:ListBucket"
                ],
                Effect = "Allow"
                Sid    = "S3List"
                Resource = [
                  "arn:aws:s3:::*",
                  "arn:aws:s3:::*/*"
                ]
            },
        ]
    })
}

resource "aws_iam_role" "event_dumper_lambda_role" {
  name = "event_dumper_lambda_role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid    = ""
        Principal = {
          Service = "lambda.amazonaws.com"
        }
      },
    ]
  })

  inline_policy {
    name = "event_dumper_lambda_policy"
    policy = jsonencode({
      Version = "2012-10-17"
      Statement = [
        {
          Sid = "ListS3Buckets"
          Action = "s3:ListAllMyBuckets"
          Effect = "Allow"
          Resource = [ "*" ]
        },
      ]      
    })
  }
}

resource "aws_iam_role_policy_attachment" "lambda_logs" {
  role       = aws_iam_role.event_dumper_lambda_role.name
  policy_arn = aws_iam_policy.lambda_logging.arn
}