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
    egress {
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }
    tags = {
        Name = "bkr_public_access"
    }
}

#create our key
resource "aws_key_pair" "key" {
    key_name = "bkr_key"
    public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDnYILW1BGsbrBXfbHbxdY16afPbQJl1djmCGi1xmGTOWzaV5OWWAL9FaqxiNS9oRKTNr4OsPVJA/0txXkhj1SNT/4ahToTso07LFRrJRmOt4siiBPYMq5wdL1wlKoUtuMfhLUNYtYfoQ8o/VNEwXi4sqk7MxSXPDYbwrWH17ikdU7uv6W0wBeHH7dkKhNfyngppGnhr8LHJkDv41ET1xp2yfe7wN8pbDNMgnfFZBGT9PcYafcR+3rHYy6YCpt7nROWvj3UrX53FivRmgdgWkqMulYZEeElTKC6C+HFCBlgISh7W2DuDAC8xHYzW2KonQu4X5OLPlxP2/3kkmeB9FkFO9bVQq5WVm9BA4PU4dlS6l1vTK3h+g6GT66LjQ7s1dbTrujvM6j2pSdRrEDsjdSwP1yNaapN3ukRT+YZjyOAKU4vBwlTop5vIG9QMFeSj8BnVQcGX1OycVCmrHUEuT+htQ6C2VoD4C/nuYa8+YvTmT4KkNDbN1sJrhrkh4wIzzU= bkr_key"      
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
    user_data = "${file("fe.sh")}"
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
    egress {
        from_port = 0
        to_port = 00
        protocol = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }
    tags = {
        Name = "bkr_private_db_access"
    }
}

#create an EC2 instance for database
resource "aws_instance" "bkr_ec2_db" {
    ami = "ami-0ed9277fb7eb570c9"
    instance_type = "t2.micro"
    subnet_id = aws_subnet.bkr-backend.id
    vpc_security_group_ids = [aws_security_group.bkr_private_db_access.id]
    key_name = "bkr_key"
    tags = {
        Name = "bkr_ec2_db"
    }
    user_data = "${file("db.sh")}"
}

#create a backend security group 
resource "aws_security_group" "bkr_private_be_access" {
    name = "bkr_private_be_access"
    vpc_id = aws_vpc.BKR-VPC.id

    ingress {
        from_port = 22
        to_port = 22
        protocol = "tcp"
        cidr_blocks = ["10.0.1.0/24"]
    }
    ingress {
        from_port = 5000
        to_port = 5000
        protocol = "tcp"
        cidr_blocks = ["10.0.1.0/24"]
    }
    ingress {
        from_port = 27017
        to_port = 27017
        protocol = "tcp"
        cidr_blocks = ["10.0.2.0/24"]
    }
    egress {
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }
    tags = {
        Name = "bkr_private_be_access"
    }
}

#create an EC2 instance for backend
resource "aws_instance" "bkr_ec2_be" {
    ami = "ami-0ed9277fb7eb570c9"
    instance_type = "t2.micro"
    subnet_id = aws_subnet.bkr-backend.id
    vpc_security_group_ids = [aws_security_group.bkr_private_be_access.id]
    key_name = "bkr_key"
    tags = {
        Name = "bkr_ec2_be"
    }
    user_data = "${file("be.sh")}"
}



