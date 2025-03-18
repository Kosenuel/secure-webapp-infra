variable "region" {
  description = "This is the region in which aws would deploy vpc"
  default     = "eu-west-2"
}

variable "az1" {
  description = "This is the availability zone in which aws would deploy vpc"
  default     = "eu-west-2a"
}

variable "az2" {
  description = "This is the availability zone in which aws would deploy vpc"
  default     = "eu-west-2b"
}

variable "s3_bucket_name" {
  description = "This is the name of the s3 bucket that lambda functions would talk to"
}

# variable "s3_bucket_arn" {
#   description = "This is the arn of the s3 bucket that lambda functions would talk to"
# }

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

