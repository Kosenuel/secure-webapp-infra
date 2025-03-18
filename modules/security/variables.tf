variable "vpc_id" {
    description = "This is the vpc id to apply security settings to"
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

