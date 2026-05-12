# Build subnet maps so we can create subnets with for_each.
locals {
  public_subnets  = { for idx, cidr in var.public_subnet_cidrs : idx => cidr }
  private_subnets = { for idx, cidr in var.private_subnet_cidrs : idx => cidr }
}

# Create the environment VPC boundary.
resource "aws_vpc" "this" {
  cidr_block           = var.vpc_cidr
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = merge(var.tags, {
    Name = "${var.name}-vpc"
  })
}

# Attach an Internet Gateway for public outbound/inbound traffic.
resource "aws_internet_gateway" "this" {
  vpc_id = aws_vpc.this.id

  tags = merge(var.tags, {
    Name = "${var.name}-igw"
  })
}

# Create public subnets for internet-facing workloads.
resource "aws_subnet" "public" {
  for_each = local.public_subnets

  vpc_id                  = aws_vpc.this.id
  cidr_block              = each.value
  availability_zone       = var.azs[tonumber(each.key)]
  map_public_ip_on_launch = true

  tags = merge(var.tags, {
    Name = "${var.name}-public-${each.key}"
    Tier = "public"
  })
}

# Create private subnets for internal services like databases.
resource "aws_subnet" "private" {
  for_each = local.private_subnets

  vpc_id            = aws_vpc.this.id
  cidr_block        = each.value
  availability_zone = var.azs[tonumber(each.key)]

  tags = merge(var.tags, {
    Name = "${var.name}-private-${each.key}"
    Tier = "private"
  })
}

# Route internet traffic from public subnets through the IGW.
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.this.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.this.id
  }

  tags = merge(var.tags, {
    Name = "${var.name}-public-rt"
  })
}

# Associate each public subnet with the public route table.
resource "aws_route_table_association" "public" {
  for_each = aws_subnet.public

  subnet_id      = each.value.id
  route_table_id = aws_route_table.public.id
}

# Group private subnets for RDS placement.
resource "aws_db_subnet_group" "this" {
  name       = "${var.name}-db-subnets"
  subnet_ids = [for subnet in aws_subnet.private : subnet.id]

  tags = merge(var.tags, {
    Name = "${var.name}-db-subnets"
  })
}
