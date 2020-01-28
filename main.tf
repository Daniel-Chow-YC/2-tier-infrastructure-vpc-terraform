# Configure the AWS provider
provider "aws" {
  region = "eu-west-1"
}


# create vpc
resource "aws_vpc" "two_tier_vpc" {
  cidr_block =  "10.0.0.0/16"
  tags = {
    Name = var.name
  }
}


# Internet Gateway
resource "aws_internet_gateway" "vpc_gw" {
  vpc_id = aws_vpc.two_tier_vpc.id

  tags = {
    Name = "${var.name} - IG"
  }
}


# create a public subnet
resource "aws_subnet" "vpc_public_subnet" {
  vpc_id            = aws_vpc.two_tier_vpc.id
  cidr_block        = "10.0.0.0/24"
  availability_zone = "eu-west-1a"
  tags = {
   Name = var.name
  }
}


# Route table for public subnet
resource "aws_route_table" "vpc_route_public" {
  vpc_id = aws_vpc.two_tier_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.vpc_gw.id

  }
  tags = {
    Name = "${var.name} - route table public"
  }
}


# Public Route table associations
resource "aws_route_table_association" "vpc_assoc_public" {
  subnet_id      = aws_subnet.vpc_public_subnet.id
  route_table_id = aws_route_table.vpc_route_public.id
}


# create a private subnet
resource "aws_subnet" "vpc_private_subnet" {
  vpc_id            = aws_vpc.two_tier_vpc.id
  cidr_block        = "10.0.1.0/24"
  availability_zone = "eu-west-1a"
  tags = {
   Name = var.name
  }
}

# Route table for private subnet
resource "aws_route_table" "vpc_route_private" {
  vpc_id = aws_vpc.two_tier_vpc.id

  tags = {
    Name = "${var.name} - route table private"
  }
}


# Private Route table associations
resource "aws_route_table_association" "vpc_assoc_private" {
  subnet_id      = aws_subnet.vpc_private_subnet.id
  route_table_id = aws_route_table.vpc_route_private.id
}
