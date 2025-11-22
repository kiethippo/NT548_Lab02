terraform {
  backend "s3" {
    bucket = "nt548-kiethuynh-terraform-state"
    key = "./terraform.tfstate"
    region         = "ap-southeast-1"
    dynamodb_table = "dynamodb-lock-table"
    encrypt        = true
    
  }
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }

  required_version = ">= 1.6.0"
}

provider "aws" {
  region = var.aws_region
}
