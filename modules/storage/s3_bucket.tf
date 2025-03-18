# Create S3 Bucket
resource "aws_s3_bucket" "sftp_bucket" {
  bucket = "sftp-bucket-sftp-bucket-retrieve-items-from-secure-webapp" # ${random_id.bucket_suffix.hex}" # The initial value I set here was invalid.

  tags = merge(
    # var.tags,
    {
      Name = "SFTP/Public-Bucket"
    }
  )

}

# resource "aws_s3_bucket" "sftp_bucket" {
#   bucket = "sftp-bucket-${random_id.bucket_suffix.hex}"

#   tags = merge(
#     var.tags,
#     {
#       Name = "SFTP/Public-Bucket"
#     }
#   )
# }


resource "random_id" "bucket_suffix" {
  byte_length = 8
}

# Set bucket ACL
# resource "aws_s3_bucket_acl" "sftp_bucket_acl" {
#   bucket = aws_s3_bucket.sftp_bucket.id
#   acl    = "public-read"
# }

resource "aws_s3_bucket_public_access_block" "unblock_default_sftp_bucket_blocks" {
  bucket                    = aws_s3_bucket.sftp_bucket.id
  block_public_acls         = false
  block_public_policy       = false
  ignore_public_acls        = false
  restrict_public_buckets   = false
}

resource "aws_s3_bucket_policy" "allow_public_read_write" {
  bucket = aws_s3_bucket.sftp_bucket.id
  policy = jsonencode(
  {
    "Version": "2012-10-17",
    "Statement": [
    {
      "Effect": "Allow",
      "Principal": "*",
      "Action": [
        "s3:GetObject",
        "s3:PutObject",
        "s3:PutBucketAcl",
        "s3:PutBucketNotification"
      ]
      "Resource": [
        "arn:aws:s3:::${aws_s3_bucket.sftp_bucket.id}",
        "arn:aws:s3:::${aws_s3_bucket.sftp_bucket.id}/*"
      ]
    }]
  }
  )
}