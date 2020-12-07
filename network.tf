resource "aws_vpc" "lamp-vpc" {
  cidr_block           = "10.44.0.0/16"
  enable_dns_hostnames = true
  tags = {
    Name = "lamp-VPC"
  }
}

resource "aws_subnet" "subnet-1" {
  cidr_block        = "10.44.1.0/24"
  vpc_id            = aws_vpc.lamp-vpc.id
  availability_zone = "us-east-1a"
  map_public_ip_on_launch = true
  tags = {
    Name = "lamp-Subnet-1"
  }
}

resource "aws_route_table" "lamp-route-table" {
  vpc_id = aws_vpc.lamp-vpc.id
  tags = {
    Name = "lamp-Public-RouteTable"
  }
}

resource "aws_route_table_association" "public-route-association" {
  route_table_id = aws_route_table.lamp-route-table.id
  subnet_id      = aws_subnet.subnet-1.id
}

resource "aws_internet_gateway" "lamp-igw" {
  vpc_id = aws_vpc.lamp-vpc.id
  tags = {
    Name = "lamp-IGW"
  }
}

resource "aws_route" "lamp-igw-route" {
  route_table_id         = aws_route_table.lamp-route-table.id
  gateway_id             = aws_internet_gateway.lamp-igw.id
  destination_cidr_block = "0.0.0.0/0"
}
