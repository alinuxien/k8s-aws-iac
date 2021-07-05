resource "aws_vpc" "cluster-vpc" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_hostnames = true
  tags = {
    Project = var.project_name
    Name    = "cluster-vpc"
  }
}

resource "aws_subnet" "public-a" {
  vpc_id            = aws_vpc.cluster-vpc.id
  cidr_block        = "10.0.100.0/24"
  availability_zone = data.aws_availability_zones.region_azs.names[0]
  tags = {
    Project = var.project_name
    Name    = "public-a"
  }
}

resource "aws_subnet" "public-b" {
  vpc_id            = aws_vpc.cluster-vpc.id
  cidr_block        = "10.0.101.0/24"
  availability_zone = data.aws_availability_zones.region_azs.names[1]
  tags = {
    Project = var.project_name
    Name    = "public-b"
  }
}

resource "aws_subnet" "private-a" {
  vpc_id            = aws_vpc.cluster-vpc.id
  cidr_block        = "10.0.0.0/24"
  availability_zone = data.aws_availability_zones.region_azs.names[0]
  tags = {
    Project = var.project_name
    Name    = "private-a"
  }
}

resource "aws_subnet" "private-b" {
  vpc_id            = aws_vpc.cluster-vpc.id
  cidr_block        = "10.0.1.0/24"
  availability_zone = data.aws_availability_zones.region_azs.names[1]
  tags = {
    Project = var.project_name
    Name    = "private-b"
  }
}

resource "aws_internet_gateway" "internet-gateway" {
  vpc_id = aws_vpc.cluster-vpc.id
  tags = {
    Project = var.project_name
    Name    = "internet-gateway"
  }
}

resource "aws_eip" "nat-gateway-public-a-ip" {
  vpc = true
}

resource "aws_nat_gateway" "nat-gateway-public-a" {
  allocation_id = aws_eip.nat-gateway-public-a-ip.id
  subnet_id     = aws_subnet.public-a.id
}

resource "aws_eip" "nat-gateway-public-b-ip" {
  vpc = true
}

resource "aws_nat_gateway" "nat-gateway-public-b" {
  allocation_id = aws_eip.nat-gateway-public-b-ip.id
  subnet_id     = aws_subnet.public-b.id
}

resource "aws_route_table" "public-a-route-to-internet" {
  vpc_id = aws_vpc.cluster-vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.internet-gateway.id
  }
  tags = {
    Project = var.project_name
    Name    = "public-a-route-to-internet"
  }
}

resource "aws_route_table" "public-b-route-to-internet" {
  vpc_id = aws_vpc.cluster-vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.internet-gateway.id
  }
  tags = {
    Project = var.project_name
    Name    = "public-b-route-to-internet"
  }
}

resource "aws_route_table" "private-a-route-to-internet" {
  vpc_id = aws_vpc.cluster-vpc.id
  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat-gateway-public-a.id
  }
  tags = {
    Project = var.project_name
    Name    = "private-a-route-to-internet"
  }
}

resource "aws_route_table" "private-b-route-to-internet" {
  vpc_id = aws_vpc.cluster-vpc.id
  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat-gateway-public-b.id
  }
  tags = {
    Project = var.project_name
    Name    = "private-b-route-to-internet"
  }
}

resource "aws_route_table_association" "public-a-route-table-association" {
  subnet_id      = aws_subnet.public-a.id
  route_table_id = aws_route_table.public-a-route-to-internet.id
}

resource "aws_route_table_association" "public-b-route-table-association" {
  subnet_id      = aws_subnet.public-b.id
  route_table_id = aws_route_table.public-b-route-to-internet.id
}

resource "aws_route_table_association" "private-a-route-table-association" {
  subnet_id      = aws_subnet.private-a.id
  route_table_id = aws_route_table.private-a-route-to-internet.id
}

resource "aws_route_table_association" "private-b-route-table-association" {
  subnet_id      = aws_subnet.private-b.id
  route_table_id = aws_route_table.private-b-route-to-internet.id
}

