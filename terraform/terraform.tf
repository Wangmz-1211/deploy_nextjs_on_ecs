terraform {

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }

  backend "s3" {
    bucket  = "wangmz-terraform-backend"
    key     = "terraform.tfstate"
    region  = "ap-northeast-1"
    encrypt = false
  }
}

provider "aws" {
  region = var.region
}
