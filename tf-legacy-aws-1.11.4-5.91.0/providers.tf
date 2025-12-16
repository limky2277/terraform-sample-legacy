# Configure the AWS Provider
terraform {
  required_version = "1.11.4"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.91"
    }
  }
}

provider "aws" {
  region = "us-east-1" # Replace with your desired AWS region
}