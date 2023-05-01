resource "aws_vpc" "example_vpc" {
  cidr_block = "10.0.0.0/16"
  enable_dns_hostnames = true
  enable_dns_support = true
}

locals {
  azs = data.aws_availability_zones.available.names
}

resource "aws_subnet" "public_subnet" {
  count = length(local.azs)
  vpc_id = aws_vpc.example_vpc.id
  cidr_block = "10.0.${count.index + 1}.0/24"
  availability_zone = local.azs[count.index]
}

resource "aws_subnet" "private_subnet" {
  count = length(local.azs)
  vpc_id = aws_vpc.example_vpc.id
  cidr_block = "10.0.${count.index + 5}.0/24"
  availability_zone = local.azs[count.index]
}

resource "aws_internet_gateway" "example_igw" {
  vpc_id = aws_vpc.example_vpc.id
}

resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.example_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.example_igw.id
  }

  tags = {
    Name = "Public Route Table"
  }
}

resource "aws_route_table_association" "public_rta" {
  count = length(local.azs)
  subnet_id = aws_subnet.public_subnet[count.index].id
  route_table_id = aws_route_table.public_rt.id
}

output "vpc_id" {
  value = aws_vpc.example_vpc.id
}

output "public_subnet_ids" {
  value = aws_subnet.public_subnet.*.id
}

output "private_subnet_ids" {
  value = aws_subnet.private_subnet.*.id
}
