resource "aws_security_group" "lb_sg" {
  name = "lb-sg"
  vpc_id = var.vpc_id

  ingress {
    from_port = 80
    to_port = 80
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_lb" "lb" {
  name = "my-lb"
  subnets = var.public_subnet_ids
  security_groups = [aws_security_group.lb_sg.id]
}

resource "aws_lb_target_group" "tg" {
  name = "my-tg"
  port = 80
  protocol = "HTTP"
  vpc_id = var.vpc_id
}

resource "aws_lb_listener" "listener" {
  load_balancer_arn = aws_lb.lb.arn
  port = 80
  protocol = "HTTP"

  default_action {
    type = "forward"
    target_group_arn = aws_lb_target_group.tg.arn
  }
}

output "lb_dns_name" {
  value = aws_lb.lb.dns_name
}
