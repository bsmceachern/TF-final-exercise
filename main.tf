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

#route table to public subnet assoc
resource "aws_route_table_association" "rt-to-public-subnet" {
    subnet_id = aws_subnet.BKR-frontend.id
    route_table_id = aws_route_table.bkr-route-table-public.id
}

#create a public security group 
resource "aws_security_group" "bkr_public_access" {
    name = "bkr_public_access"
    vpc_id = aws_vpc.BKR-VPC.id

    ingress {
        from_port = 22
        to_port = 22
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }
    ingress {
        from_port = 80
        to_port = 80
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }
    ingress {
        from_port = 5000
        to_port = 5000
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }
    tags = {
        Name = "bkr_public_access"
    }
}

#create our key
resource "aws_key_pair" "key" {
    key_name = "bkr_key"
    public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDRRO2PdrjgGPeMyH/K7nje744UDuFyUJdzWTuOWWAsi0XD37yP/OHc5e+WY/MfvtxGNIXin/cwPmL1KdMvdOfnW2+55Hya1Fb2lfNgAEdoBnZlPWE195pdtH/wz9rG4ggqKYJVPTGy+xGFX65PLJVFuYuUrGs37/URK4i5TI+8U6q+UX0GQOjGItjzTLdoTRvLfXhNny/bWRbQiAYoN8JPMttKzTnUkyjvrnHc3hOv/3qKj/y9afCZD6lXjVRm22Lm4mtDJG8ucEtAiXY6MK4IrIsgRzC7xupVy7nNg8N5jrtl6viMFC45n4XAIqofugg5xp7Q9jp7BxzaUMlBo5u59Rv6TAOnMh8oa30FPMac5JwyWhNGlZgrnfPfzAsEcG8rlMLAS54EdPUU1msojKQ7cHuunJxXOqox4OcDAtDKoeE/4JqZ8EemChd7xNgYZMRUfLofsTMB5Ne4L5Re8Rmklu/eIIDrty9/a1MV+ck60gwNSJ+ZdWH+QPViPh3YEJU= bkr_key"      
}

#create an EC2 instance for front end
resource "aws_instance" "bkr_ec2_fe" {
    ami = "ami-0ed9277fb7eb570c9"
    instance_type = "t2.micro"
    subnet_id = aws_subnet.BKR-frontend.id
    vpc_security_group_ids = [aws_security_group.bkr_public_access.id]
    key_name = "bkr_key"
    tags = {
        Name = "bkr_ec2_fe"
    }
    #user_data = "${file("fe.sh")}"
}

#create private subnet
resource "aws_subnet" "bkr-backend" {
    vpc_id = aws_vpc.BKR-VPC.id
    cidr_block = "10.0.2.0/24"
        tags = {
        Name = "bkr-backend"
    }
}

#create a private database security group 
resource "aws_security_group" "bkr_private_db_access" {
    name = "bkr_private_db_access"
    vpc_id = aws_vpc.BKR-VPC.id

    ingress {
        from_port = 22
        to_port = 22
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }
    ingress {
        from_port = 27017
        to_port = 27017
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }
    ingress {
        from_port = 5000
        to_port = 5000
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }
    tags = {
        Name = "bkr_private_db_access"
    }
}
