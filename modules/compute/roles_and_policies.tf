# IAM Role for to allow Lambda functions to access S3 and SFTP resources
resource "aws_iam_role" "lambda_role" {
  name = "lambda-sftp-s3-role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action = "sts:AssumeRole",
        Effect = "Allow",
        Principal = {
          Service = "lambda.amazonaws.com"
        },
      },
    ],
  })
}

# Policy to allow Lambda to access S3 bucket
resource "aws_iam_policy" "lambda_s3_policy_1" {
  name        = "lambda-s3-policy_1"
  description = "Policy to allow Lambda functions access S3 bucket"

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action = [
          "s3:GetObject",
          "s3:PutObject",
          "s3:ListBucket",
          "s3:",
          "events:"
        ],
        Effect = "Allow",
        Resource = [
          "${var.s3_bucket_arn}",
          "${var.s3_bucket_arn}/*"
        ]
      }
    ]
  })
}

# Policy to allow Lambda to create CloudWatch Logs
resource "aws_iam_policy" "lambda_logging_policy" {
  name        = "lambda-logging-policy"
  description = "Policy to allow Lambda functions to write logs to CloudWatch"

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action = [
          "logs:CreateLogGroup",
          "logs:",
          "ec2:",
          "logs:CreateLogStream",
          "logs:PutLogEvents",
          "logs:DescribeLogStreams",
          "logs:DescribeLogGroups"
        ],
        Effect   = "Allow",
        Resource = [
          "arn:aws:logs:${var.region}:${var.account_id}:*",
          "arn:aws:logs:${var.region}:${var.account_id}:log-group:/aws/lambda/*",
        ]
      }
    ]
  })
}

resource "aws_iam_policy" "lambda_vpc_access_policy" {
  name   = "lambda-vpc-access-policy"
  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action = [
          "ec2:CreateNetworkInterface",
          "ec2:DescribeNetworkInterfaces",
          "ec2:DeleteNetworkInterface"
        ],
        Resource  = "*",
        Effect    = "Allow"
      }
    ]
  }
  )
}

resource "aws_iam_policy" "lambda_s3_policy" {
  name   = "lambda_s3_policy"
  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow", 
        Action = [
          "s3:GetObject",
          "s3:PutObject",
        ],
        Resource = [
          "arn:aws:s3:::${var.s3_bucket_arn}",
          "arn:aws:s3:::${var.s3_bucket_arn}/*"
        ]
      }
    ]
  })
}
 
# Attach policies to IAM role
resource "aws_iam_role_policy_attachment" "s3_policy_attachment" {
  role       = aws_iam_role.lambda_role.name
  policy_arn = aws_iam_policy.lambda_s3_policy_1.arn
}

resource "aws_iam_role_policy_attachment" "logging_policy_attachment" {
  role       = aws_iam_role.lambda_role.name
  policy_arn = aws_iam_policy.lambda_logging_policy.arn
}

resource "aws_iam_role_policy_attachment" "lambda_vpc_access_policy_attachment" {
  role       = aws_iam_role.lambda_role.name
  policy_arn = aws_iam_policy.lambda_vpc_access_policy.arn
}

resource "aws_iam_role_policy_attachment" "s3_access_policy_attach" {
  role       = aws_iam_role.lambda_role.name
  policy_arn = aws_iam_policy.lambda_s3_policy.arn
}