terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.0"
    }
  }
}

provider "aws" {
  region = "us-east-1"
}

#VPC
resource "aws_vpc" "BKR-VPC" {
    cidr_block = "10.0.0.0/16"

    tags = {
        Name = "bkr-vpc"
    }
}