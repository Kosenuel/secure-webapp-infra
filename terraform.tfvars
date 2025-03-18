region               = "eu-west-2"
account_id           = "412381775336"
az1                  = "eu-west-2a"
az2                  = "eu-west-2b"
ami                  = "ami-00710ab5544b60cf7" # Amazon Linux for "eu-west-2" Region
webapp_instance_type = "t2.small"
sftp_instance_type   = "t2.small"


tags = {
  Environment       = "Production"
  Owner             = "Emmanuel Okose"
  Terraform-Managed = "True"
  Project           = "Secure Ops (Web-App)"
}