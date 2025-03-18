output "s3_bucket_name" {
    value = aws_s3_bucket.sftp_bucket.bucket
}

output "s3_bucket_id" {
    value = aws_s3_bucket.sftp_bucket.id
}

output "s3_bucket_arn" {
    value = aws_s3_bucket.sftp_bucket.arn
}

output "s3_bucket_endpoint" {
    value = aws_s3_bucket.sftp_bucket.website_endpoint
}