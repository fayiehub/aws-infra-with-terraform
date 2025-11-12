terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "6.18.0"
    }
  }
}

# Configure the AWS Provider
provider "aws" {
  region = "us-east-1"
  access_key = "**************"
  secret_key = "**************************************"
}

# Create VPC
# resource "aws_vpc" "vpc-1" {
#   cidr_block = "10.1.0.0/16"
#   tags = {
#     Name = "prod-vpc"
#   }
# }

# # Create Internet Gateway
# resource "aws_internet_gateway" "igw" {
#   vpc_id = aws_vpc.vpc-1.id
#   tags = {
#     Name = "prod-igw"
#   }
# }

# # Create Custom Route Table
# resource "aws_route_table" "rt" {
#   vpc_id = aws_vpc.vpc-1.id
#   route {
#     cidr_block = "0.0.0.0/0"
#     gateway_id = aws_internet_gateway.igw.id
#   }
#   route {
#     ipv6_cidr_block        = "::/0"
#     gateway_id = aws_internet_gateway.igw.id
#   }
#   tags = {
#     Name = "prod-rt"
#   }
# }

# variable subnet_prefix {
#   # default     = "" # for when there's no value in the tfvars file.
#   description = "prefix for the subnet"
# }


# # Create Subnet
# resource "aws_subnet" "subnet-1" {
#   vpc_id     = aws_vpc.vpc-1.id
#   cidr_block = var.subnet_prefix[0].cidr_block
#   availability_zone = "us-east-1a"

#   tags = {
#     Name = var.subnet_prefix[0].name
#   }
# }

# resource "aws_subnet" "subnet-2" {
#   vpc_id     = aws_vpc.vpc-1.id
#   cidr_block = var.subnet_prefix[1].cidr_block
#   availability_zone = "us-east-1a"

#   tags = {
#     Name = var.subnet_prefix[1].name
#   }
# }

# # Associate subnet with route table
# resource "aws_route_table_association" "rta" {
#   subnet_id      = aws_subnet.subnet-1.id
#   route_table_id = aws_route_table.rt.id
# }

# # Create security group 
# resource "aws_security_group" "sg-1-prod" {
#   name        = "allow-web-traffic"
#   description = "Allow Web traffic"
#   vpc_id      = aws_vpc.vpc-1.id

#   tags = {
#     Name = "prod-sg"
#   }
# }

# # Create security group rules with ports 22,80,443 open
# resource "aws_vpc_security_group_ingress_rule" "allow_443_ipv4" {
#   security_group_id = aws_security_group.sg-1-prod.id
#   description       = "HTTPS"
#   cidr_ipv4         = "0.0.0.0/0"
#   from_port         = 443
#   ip_protocol       = "tcp"
#   to_port           = 443
# }

# resource "aws_vpc_security_group_ingress_rule" "allow_80_ipv4" {
#   security_group_id = aws_security_group.sg-1-prod.id
#   description       = "HTTP"
#   cidr_ipv4         = "0.0.0.0/0"
#   from_port         = 80
#   ip_protocol       = "tcp"
#   to_port           = 80
# }

# resource "aws_vpc_security_group_ingress_rule" "allow_22_ipv4" {
#   security_group_id = aws_security_group.sg-1-prod.id
#   description       = "SSH"
#   cidr_ipv4         = "0.0.0.0/0"
#   from_port         = 22
#   ip_protocol       = "tcp"
#   to_port           = 22
# }

# resource "aws_vpc_security_group_egress_rule" "allow_all_traffic_ipv4" {
#   security_group_id = aws_security_group.sg-1-prod.id
#   cidr_ipv4         = "0.0.0.0/0"
#   ip_protocol       = "-1" # semantically equivalent to all ports
# }

# # Create NIC
# resource "aws_network_interface" "nic-1" {
#   subnet_id       = aws_subnet.subnet-1.id
#   private_ips     = ["10.1.1.30"]
#   security_groups = [aws_security_group.sg-1-prod.id]
# }

# # Attach Elastic IP to ENI above
# # NOTE: An Elastic IP can only be created in a vpc/subnet with an internet gateway.
# resource "aws_eip" "eip" {
#   domain                    = "vpc"
#   network_interface         = aws_network_interface.nic-1.id
#   associate_with_private_ip = "10.1.1.30"
#   depends_on                = [aws_internet_gateway.igw]
# }

# output "server_public_ip" {
#   value       = aws_eip.eip.public_ip
#   description = "Public IP attached to our elastic ip"

# }


# # Create Ubuntu server
# resource "aws_instance" "example" {
#   ami           = "ami-0bdd88bd06d16ba03"
#   instance_type = "t3.micro"
#   availability_zone = "us-east-1a"
#   key_name      = "lets-test-this-kp"

#   primary_network_interface {
#     network_interface_id = aws_network_interface.nic-1.id
#   }

#   tags = {
#     Name = "prod-webserver"
#   }

# # install apache in web server
#   user_data = <<-EOF
#               #!/bin/bash
#               sudo yum update -y
#               sudo yum install httpd -y
#               sudo systemctl start httpd
#               sudo bash echo "Your prod server is up > /var/www/html/index.html"
#               curl -I http://localhost
#               EOF
# }

# output "server_volume_id" {
#   value = aws_instance.example.root_block_device
# }
# output "server_private_ip" {
#   value = aws_instance.example.private_ip
# }
# output "server_public_dns" {
#   value = aws_instance.example.public_dns
# }
# output "server_id" {
#   value = aws_instance.example.id
# }

