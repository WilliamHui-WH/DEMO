resource "aws_security_group" "web_sg" {
  name_prefix = "web-sg-"
  vpc_id = var.vpc_id

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

resource "aws_instance" "web_instance" {
  count = 2
  ami = "ami-0c55b159cbfafe1f0"
  instance_type = "t2.micro"
  key_name = "mykey"
  subnet_id = var.public_subnet_ids[count.index % length(var.public_subnet_ids)]
  vpc_security_group_ids = [aws_security_group.web_sg.id]
  tags = {
    Name = "web-${count.index + 1}"
  }
}

resource "aws_security_group" "app_sg" {
  name_prefix = "app-sg-"
  vpc_id = var.vpc_id

  ingress {
    from_port = 8080
    to_port = 8080
    protocol = "tcp"
    security_groups = [aws_security_group.web_sg.id]
  }
}

resource "aws_instance" "app_instance" {
  count = 2
  ami = "ami-0c55b159cbfafe1f0"
  instance_type = "t2.micro"
  key_name = "mykey"
  subnet_id = var.private_subnet_ids[count.index % length(var.private_subnet_ids)]
  vpc_security_group_ids = [aws_security_group.app_sg.id]
  tags = {
    Name = "app-${count.index + 1}"
  }
}

output "web_sg_id" {
  value = aws_security_group.web_sg.id
}
