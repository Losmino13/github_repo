# 10.10.0.1 -> 10.10.15.254
resource "aws_vpc" "three_tier_vpc" {
  cidr_block = "10.10.0.0/20"
  tags = {
    Name = "3tier_vpc"
  }
}

# WEB

resource "aws_subnet" "web_subnet_1" {
  vpc_id                  = aws_vpc.three_tier_vpc.id
  cidr_block              = "10.10.1.0/24"
  availability_zone       = "eu-west-1a"
  map_public_ip_on_launch = true
  tags = {
    Name = "Web1"
  }
}

resource "aws_subnet" "web_subnet_2" {
  vpc_id                  = aws_vpc.three_tier_vpc.id
  cidr_block              = "10.10.2.0/24"
  availability_zone       = "eu-west-1b"
  map_public_ip_on_launch = true
  tags = {
    Name = "Web2"
  }
}

# APP

resource "aws_subnet" "app_subnet_1" {
  vpc_id            = aws_vpc.three_tier_vpc.id
  cidr_block        = "10.10.3.0/24"
  availability_zone = "eu-west-1a"
  tags = {
    Name = "App1"
  }
}

resource "aws_subnet" "app_subnet_2" {
  vpc_id            = aws_vpc.three_tier_vpc.id
  cidr_block        = "10.10.4.0/24"
  availability_zone = "eu-west-1b"
  tags = {
    Name = "App2"
  }
}

# DB

resource "aws_subnet" "db_subnet_1" {
  vpc_id            = aws_vpc.three_tier_vpc.id
  cidr_block        = "10.10.5.0/24"
  availability_zone = "eu-west-1a"
  tags = {
    Name = "DB1"
  }
}

resource "aws_subnet" "db_subnet_2" {
  vpc_id            = aws_vpc.three_tier_vpc.id
  cidr_block        = "10.10.6.0/24"
  availability_zone = "eu-west-1b"
  tags = {
    Name = "DB2"
  }
}

# IGW

resource "aws_internet_gateway" "three_tier_igw" {
  vpc_id = aws_vpc.three_tier_vpc.id

  tags = {
    Name = "3tier IGW"
  }
}

# ROUTE TABLE

resource "aws_route_table" "three_tier_route_table" {
  vpc_id = aws_vpc.three_tier_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.three_tier_igw.id
  }

  tags = {
    Name = "3tier route table"
  }
}

resource "aws_route_table_association" "web1" {
  subnet_id      = aws_subnet.web_subnet_1.id
  route_table_id = aws_route_table.three_tier_route_table.id
}

resource "aws_route_table_association" "web2" {
  subnet_id      = aws_subnet.web_subnet_2.id
  route_table_id = aws_route_table.three_tier_route_table.id
}