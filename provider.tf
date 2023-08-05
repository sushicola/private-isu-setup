terraform {
  required_version = "= 1.3.6"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "4.47.0"
    }
  }
}

variable "access_key" {}
variable "secret_key" {}

provider "aws" {
  access_key = var.access_key
  secret_key = var.secret_key
  region = local.region
  default_tags {
    tags = {
      ManagedBy = "Terraform"
      Scope = local.app_name
    }
  }
}
