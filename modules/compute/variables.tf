variable "ami" {
  description = "This is the image type used for all the ec2 instances in this project (secure webapp)"
}

variable "webapp_instance_type" {
  description = "This is the instance type used for webapp ec2 instances in this project (secure webapp)"
}

variable "sftp_instance_type" {
  description = "This is the instance type used for the sftp ec2 instances in this project (secure webapp)"
}

variable "webapp_sg" {
  description = "This is the secure webapp security group (usually generated from the security module)"
}

variable "lambda_sg" {
  description = "The the security group for the lambda functions"
}

variable "sftp_sg" {
  description = "This is the sftp security group"
}

variable "priv_sub1" {
  description = "This is first private subnet"
}

variable "priv_sub2" {
  description = "This is the second private subnet"
}

variable "s3_bucket_name" {
    description = "This the name for the public s3 bucket that would interact with the sftp server via lambda fxns"
}

variable "s3_bucket_id" {
    description = "This the ID for the public s3 bucket that would interact with the sftp server via lambda fxns"
}

variable "s3_bucket_arn" {
    description = "This is the amazon-resource-name (arn) of the s3 bucket that would be talking to the sftp server via lambda fxns"
}

variable "region" {
    description = "This is the where resources would be deployed to"
}

variable "account_id" {
    description = "This is the amazon ID to use in provisioning resources"
}

variable "tags" {
  description = "This is the for resources deployed in our vpc"
  type        = map(string)
  default = {
    Environment       = "Production"
    Owner             = "Emmanuel Okose"
    Terraform-Managed = "True"
    Project           = "Secure Ops (Web-App)"
  }
}

