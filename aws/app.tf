provider "aws" {
  region = "us-west-2" # Replace with your desired region
}

# Create a new VPC
resource "aws_vpc" "example_vpc" {
  cidr_block = "10.0.0.0/16"
}

# Create public and private subnets in the VPC
resource "aws_subnet" "public_subnet" {
  vpc_id = aws_vpc.example_vpc.id
  cidr_block = "10.0.1.0/24"
  availability_zone = "us-west-2a"
}

resource "aws_subnet" "private_subnet" {
  vpc_id = aws_vpc.example_vpc.id
  cidr_block = "10.0.2.0/24"
  availability_zone = "us-west-2b"
}

# Create an Internet Gateway and attach it to the VPC
resource "aws_internet_gateway" "example_igw" {
  vpc_id = aws_vpc.example_vpc.id
}

# Create a Route Table for the public subnet
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

# Associate the public subnet with the public Route Table
resource "aws_route_table_association" "public_rta" {
  subnet_id = aws_subnet.public_subnet.id
  route_table_id = aws_route_table.public_rt.id
}

# Create a Security Group for the Web Servers
resource "aws_security_group" "web_sg" {
  name_prefix = "web-sg-"
  vpc_id = aws_vpc.example_vpc.id

  ingress {
    from_port = 80
    to_port = 80
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# Launch Web Server instances in the public subnet
resource "aws_instance" "web_instance" {
  ami = "ami-0c94855ba95c71c99"
  instance_type = "t2.micro"
  subnet_id = aws_subnet.public_subnet.id
  vpc_security_group_ids = [aws_security_group.web_sg.id]
  associate_public_ip_address = true
  count = 2 # Launch two instances

  tags = {
    Name = "Web Server ${count.index + 1}"
  }
}

# Create a Security Group for the Application Servers
resource "aws_security_group" "app_sg" {
  name_prefix = "app-sg-"
  vpc_id = aws_vpc.example_vpc.id

  ingress {
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = ["10.0.1.0/24"] # Allow SSH access from the public subnet
  }
}

# Launch Application Server instances in the private subnet
resource "aws_instance" "app_instance" {
  ami = "ami-0c948
