# terraform/vpc.tf
resource "aws_vpc" "pacs_vpc" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_support   = true
  enable_dns_hostnames = true
  tags = { Name = "pacs-vna-vpc" }
}

# AZ1 - Primary
resource "aws_subnet" "az1_private" {
  vpc_id            = aws_vpc.pacs_vpc.id
  cidr_block        = "10.0.10.0/24"
  availability_zone = "us-east-1a"
  tags = { Name = "az1-private-pacs" }
}

resource "aws_subnet" "az1_public" {
  vpc_id            = aws_vpc.pacs_vpc.id
  cidr_block        = "10.0.20.0/24"
  availability_zone = "us-east-1a"
  tags = { Name = "az1-public" }
}

# AZ2 - Standby
resource "aws_subnet" "az2_private" {
  vpc_id            = aws_vpc.pacs_vpc.id
  cidr_block        = "10.0.30.0/24"
  availability_zone = "us-east-1b"
  tags = { Name = "az2-private-pacs" }
}
