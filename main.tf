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

#subnet-front end (public)
resource "aws_subnet" "BKR-frontend" {
    vpc_id = aws_vpc.BKR-VPC.id
    cidr_block = "10.0.1.0/24"
    map_public_ip_on_launch = "true"

    tags = {
        Name = "bkr-frontend"
    }
}

#Gateway
resource "aws_internet_gateway" "bkr-gateway" {
    vpc_id = aws_vpc.BKR-VPC.id

    tags = {
        Name = "bkr-igw"
    }
}

#Route table
resource "aws_route_table" "bkr-route-table-public" {
    vpc_id = aws_vpc.BKR-VPC.id

    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_internet_gateway.bkr-gateway.id
    }

    tags = {
        Name = "bkr-route-table-public"
    }
}