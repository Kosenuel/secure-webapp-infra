output "webapp_sg" {
    value = aws_security_group.webapp_sg.id
}

output "sftp_sg" {
    value = aws_security_group.sftp_sg.id
}

output "lambda_sg" {
    value = aws_security_group.lambda_sg.id
}

