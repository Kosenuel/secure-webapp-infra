# Configure the AWS Provider
provider "aws" {
  region = var.region
}

module "networking" {
  source = "./modules/networking"
  tags   = var.tags
  az1    = var.az1
  az2    = var.az2
  s3_bucket_name = module.storage.s3_bucket_name
}

module "security" {
  source = "./modules/security"
  tags   = var.tags
  vpc_id = module.networking.vpc_id
}

module "storage" {
  source = "./modules/storage"
}

module "compute" {
  source               = "./modules/compute"
  tags                 = var.tags
  ami                  = var.ami
  lambda_sg            = module.security.lambda_sg
  webapp_instance_type = var.webapp_instance_type
  sftp_instance_type   = var.sftp_instance_type
  priv_sub1            = module.networking.priv_sub1
  priv_sub2            = module.networking.priv_sub2
  webapp_sg            = module.security.webapp_sg
  sftp_sg              = module.security.sftp_sg
  s3_bucket_name       = module.storage.s3_bucket_name
  s3_bucket_arn        = module.storage.s3_bucket_arn
  region               = var.region
  account_id           = var.account_id
  s3_bucket_id         = module.storage.s3_bucket_id
}

# output "s3_bucket_endpoint" {
#   value = module.storage.s3_bucket_endpoint
# }