resource "aws_vpc" "main_vpc" {
  cidr_block = var.vpc.cidr_block
  enable_dns_support   = true
  enable_dns_hostnames = true
  assign_generated_ipv6_cidr_block = true
  enable_network_address_usage_metrics = true

  tags = var.common_tags
}

resource "aws_subnet" "private_subnets" {
  count             = length(var.private_subnets)

  vpc_id            = aws_vpc.main_vpc.id
  cidr_block        = element(var.private_subnets, count.index)
  availability_zone = element(local.azs, count.index)

  map_public_ip_on_launch = false
  
  tags = var.common_tags
}

resource "aws_subnet" "public_subnets" {
  count             = length(var.public_subnets)

  vpc_id            = aws_vpc.main_vpc.id
  cidr_block        = element(var.public_subnets, count.index)
  availability_zone = element(local.azs, count.index)

  map_public_ip_on_launch = true

  tags = var.common_tags
}

resource "aws_subnet" "nat_subnet" {
  vpc_id            = aws_vpc.main_vpc.id
  cidr_block        = var.nat_subnet
  availability_zone = local.azs[0]

  #   map_public_ip_on_launch = true

  tags = var.common_tags
}

resource "aws_internet_gateway" "main_igw" {
  vpc_id = aws_vpc.main_vpc.id

  tags = var.common_tags
}

resource "aws_eip" "nat_gateway" {
  domain                    = "vpc"
  depends_on                = [aws_internet_gateway.main_igw]

  tags = var.common_tags
}

resource "aws_nat_gateway" "main_ngw" {
  subnet_id     = aws_subnet.nat_subnet.id
  allocation_id = aws_eip.nat_gateway.id

  depends_on = [aws_eip.nat_gateway]

  tags = var.common_tags
}

# Create a route table for the public subnet
resource "aws_route_table" "public_route_table" {
  vpc_id = aws_vpc.main_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.main_igw.id
  }

  route {
    ipv6_cidr_block = "::/0"
    gateway_id = aws_internet_gateway.main_igw.id
  }
}

# Create a route table for the private subnet
resource "aws_route_table" "private_route_table" {
  vpc_id = aws_vpc.main_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.main_ngw.id
  }
}

# Associate the route table with the public subnet
resource "aws_route_table_association" "public_rta" {
  count = length(var.public_subnets)

  subnet_id      = element(aws_subnet.public_subnets[*].id, count.index)
  route_table_id = aws_route_table.public_route_table.id
}

# Associate the route table with the public subnet
resource "aws_route_table_association" "private_rta" {
  count = length(var.private_subnets)

  subnet_id      = element(aws_subnet.private_subnets[*].id, count.index)
  route_table_id = aws_route_table.private_route_table.id
}
