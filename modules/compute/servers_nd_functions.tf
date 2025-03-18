# Create EC2 Instance for Secure Webapp Server
resource "aws_instance" "webapp_server" {
  ami                         = var.ami
  instance_type               = var.webapp_instance_type
  subnet_id                   = var.priv_sub1
  vpc_security_group_ids      = [var.webapp_sg]
  associate_public_ip_address = false # This is to further ensure that it is private

  tags = merge(
    var.tags,
    {
      Name = "webapp-server"
    }
  )
}

# Create EC2 Instance for SFTP Server
resource "aws_instance" "sftp_server" {
  ami                         = var.ami
  instance_type               = var.sftp_instance_type
  subnet_id                   = var.priv_sub2
  vpc_security_group_ids      = [var.sftp_sg]
  associate_public_ip_address = false # To Ensure that it is being kept it on our private VPC

  user_data = file("${path.module}/scripts/sftp_server_userdata.sh")

  tags = merge(
    var.tags,
    {
      Name = "sftp_server"
    }
  )
}

# lambda Function 1: SFTP -> S3
resource "aws_lambda_function" "sftp_to_s3_lambda" {
  function_name = "sftp-to-s3-lambda"
  runtime       = "python3.9"
  handler       = "lambda_function.handler"
  role          = aws_iam_role.lambda_role.arn
  memory_size   = 512
  timeout       = 300
  vpc_config {
    subnet_ids         = [var.priv_sub1, var.priv_sub2]
    security_group_ids = [var.lambda_sg]
  }

  # Lambda function code zip file
  filename         = "${path.module}/scripts/sftp_to_s3_lambda_function.zip"
  source_code_hash = filebase64sha256("${path.module}/scripts/sftp_to_s3_lambda_function.zip")

  environment {
    variables = {
      SFTP_SERVER_HOST     = aws_instance.sftp_server.private_ip
      SFTP_SERVER_USER     = "sftpuser"
      SFTP_SERVER_PASSWORD = "toor"
      S3_BUCKET_NAME       = var.s3_bucket_name
      SFTP_BASE_PATH       = "/home/sftpuser/upload" # Path on SFTP server to monitor
    }
  }

  depends_on = [
    aws_iam_role_policy_attachment.s3_policy_attachment,
    aws_iam_role_policy_attachment.logging_policy_attachment
  ]
}

# Lambda Function 2: S3 -> SFTP
resource "aws_lambda_function" "s3_to_sftp_lambda" {
  function_name = "s3-to-sftp-lambda"
  runtime       = "python3.9"
  handler       = "lambda_function.handler"
  role          = aws_iam_role.lambda_role.arn
  memory_size   = 512
  timeout       = 300
  vpc_config {
    subnet_ids         = [var.priv_sub1, var.priv_sub2]
    security_group_ids = [var.lambda_sg]
  }

  # Lambda function code zip file
  filename         = "${path.module}/scripts/s3_to_sftp_lambda_function.zip"
  source_code_hash = filebase64sha256("${path.module}/scripts/s3_to_sftp_lambda_function.zip")

  environment {
    variables = {
      SFTP_SERVER_HOST     = aws_instance.sftp_server.private_ip
      SFTP_SERVER_USER     = "sftpuser"
      SFTP_SERVER_PASSWORD = "toor"
      S3_BUCKET_NAME       = var.s3_bucket_name
      SFTP_UPLOAD_PATH     = "/home/sftpuser/upload" # This is the path on the Sftp server to upload to
    }
  }

  depends_on = [
    aws_cloudwatch_log_group.s3_to_sftp_lambda_log_group,
    aws_iam_role_policy_attachment.lambda_vpc_access_policy_attachment,
    aws_iam_role_policy_attachment.s3_policy_attachment,
    aws_iam_role_policy_attachment.logging_policy_attachment
  ]
}


