variable "tags" {
  description = "These are the tags that are appended to resources for easy management"
  type = map(string)
  default = {
    Environment       = "Production"
    Owner             = "Emmanuel Okose"
    Terraform-Managed = "True"
    Project           = "Secure Ops (Web-App)"
  }
}