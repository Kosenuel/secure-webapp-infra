variable "region" {
  description = "This is the region to which Terraform would deploy resources to"
  default     = "eu-west-2"
}

variable "account_id" {
  description = "This is the account ID to which terraform would use in creating policies for its role"
}

variable "az1" {
  description = "This is the availability zone in which aws would deploy vpc"
}

variable "az2" {
  description = "This is the availability zone in which aws would deploy vpc"
}

variable "ami" {
  description = "This is the image type used for all the ec2 instances in this project (secure webapp)"
}

variable "webapp_instance_type" {
  description = "This is the instance type used for webapp ec2 instances in this project (secure webapp)"
}

variable "sftp_instance_type" {
  description = "This is the instance type used for the sftp ec2 instances in this project (secure webapp)"
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
