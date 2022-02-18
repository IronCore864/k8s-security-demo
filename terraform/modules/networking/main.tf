# creates vpc, default routing table, default security group and default network ACL
resource "aws_vpc" "main" {
  cidr_block           = var.vpc_cidr_block
  enable_dns_support   = true
  enable_dns_hostnames = true
  tags = {
    Name = var.vpc_name
  }
}

# public subnets
resource "aws_subnet" "public" {
  for_each = var.public_subnets

  vpc_id            = aws_vpc.main.id
  availability_zone = each.key
  cidr_block        = each.value

  tags = {
    Name = "public-${each.key}"
  }
}

# private subnets
resource "aws_subnet" "private" {
  for_each = var.private_subnets

  vpc_id            = aws_vpc.main.id
  availability_zone = each.key
  cidr_block        = each.value
  tags = {
    Name = "private-${each.key}"
  }
}

# internet gateway
resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.main.id
}

# elastic IP for nat gateway
resource "aws_eip" "nat_gateway" {
  for_each = var.public_subnets

  vpc = true
}

# nat gateway
resource "aws_nat_gateway" "main" {
  for_each = var.public_subnets

  allocation_id = aws_eip.nat_gateway[each.key].id
  subnet_id     = aws_subnet.public[each.key].id
}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.main.id
  }
  tags = {
    Name = "public"
  }
}

resource "aws_route_table_association" "public_subnet" {
  for_each = var.public_subnets

  subnet_id      = aws_subnet.public[each.key].id
  route_table_id = aws_route_table.public.id
}

resource "aws_route_table" "private" {
  for_each = var.private_subnets

  vpc_id = aws_vpc.main.id
  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.main[each.key].id
  }
  tags = {
    Name = "private-${each.key}"
  }
}

resource "aws_route_table_association" "private_subnet" {
  for_each = var.private_subnets

  subnet_id      = aws_subnet.private[each.key].id
  route_table_id = aws_route_table.private[each.key].id
}
