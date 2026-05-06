# VPC
resource "aws_vpc" "pacs_vpc" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name    = "pacs-ha-vpc"
    Project = "aws-dual-az-ha-architecture"
  }
}

# Internet Gateway
resource "aws_internet_gateway" "pacs_igw" {
  vpc_id = aws_vpc.pacs_vpc.id

  tags = {
    Name = "pacs-igw"
  }
}

# ── AZ1 (us-east-1a) ──────────────────────────────────
resource "aws_subnet" "public_az_a" {
  vpc_id            = aws_vpc.pacs_vpc.id
  cidr_block        = "10.0.10.0/24"
  availability_zone = "us-east-1a"

  tags = {
    Name = "public-az-a"
    Tier = "public"
  }
}

resource "aws_subnet" "private_az_a" {
  vpc_id            = aws_vpc.pacs_vpc.id
  cidr_block        = "10.0.20.0/24"
  availability_zone = "us-east-1a"

  tags = {
    Name = "private-az-a"
    Tier = "private"
  }
}

# ── AZ2 (us-east-1b) ──────────────────────────────────
resource "aws_subnet" "public_az_b" {
  vpc_id            = aws_vpc.pacs_vpc.id
  cidr_block        = "10.0.30.0/24"
  availability_zone = "us-east-1b"

  tags = {
    Name = "public-az-b"
    Tier = "public"
  }
}

resource "aws_subnet" "private_az_b" {
  vpc_id            = aws_vpc.pacs_vpc.id
  cidr_block        = "10.0.40.0/24"
  availability_zone = "us-east-1b"

  tags = {
    Name = "private-az-b"
    Tier = "private"
  }
}

# ── Route Tables ──────────────────────────────────────
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.pacs_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.pacs_igw.id
  }

  tags = {
    Name = "pacs-rt-public"
  }
}

resource "aws_route_table" "private" {
  vpc_id = aws_vpc.pacs_vpc.id

  # NAT Gateway route added when deployed
  # route {
  #   cidr_block     = "0.0.0.0/0"
  #   nat_gateway_id = aws_nat_gateway.pacs_nat_az_a.id
  # }

  tags = {
    Name = "pacs-rt-private"
  }
}

# ── Route Table Associations ──────────────────────────
resource "aws_route_table_association" "public_az_a" {
  subnet_id      = aws_subnet.public_az_a.id
  route_table_id = aws_route_table.public.id
}

resource "aws_route_table_association" "public_az_b" {
  subnet_id      = aws_subnet.public_az_b.id
  route_table_id = aws_route_table.public.id
}

resource "aws_route_table_association" "private_az_a" {
  subnet_id      = aws_subnet.private_az_a.id
  route_table_id = aws_route_table.private.id
}

resource "aws_route_table_association" "private_az_b" {
  subnet_id      = aws_subnet.private_az_b.id
  route_table_id = aws_route_table.private.id
}
