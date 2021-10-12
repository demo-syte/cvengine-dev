# Terraform Block
terraform {
  required_version = "~> 1.0.4" # which means any version equal & above  < 1.xx
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.0"

    }
  }
backend "s3" {
    bucket         = "dev-cvengine-bucket"
    key            = "dev/terraform.tfstate"
    region         = "us-west-2"
    acl            = "private"
    dynamodb_table = "dev-cvengine-lock-dynamo"

    organization = "cvengine-dev"

    workspaces {
      name = "cvengine-dev"
    }
  }
}
provider "aws" {
  region = var.REGION
}

# Adding Backend as S3 for Remote State Storage
