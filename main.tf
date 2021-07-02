provider "aws" {
  region = var.region
}

resource "aws_vpc" "vpc" {
  cidr_block           = var.cidr_vpc
  enable_dns_support   = true
  enable_dns_hostnames = true
  tags = {
    Name = "aakulov-aws1"
  }
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.vpc.id

  tags = {
    Name = "aakulov-aws1"
  }
}

resource "aws_subnet" "subnet1" {
  vpc_id            = aws_vpc.vpc.id
  cidr_block        = var.cidr_subnet1
  availability_zone = "eu-central-1b"
}

resource "aws_subnet" "subnet2" {
  vpc_id            = aws_vpc.vpc.id
  cidr_block        = var.cidr_subnet2
  availability_zone = "eu-central-1a"
}

resource "aws_route_table" "aws1-1" {
  vpc_id = aws_vpc.vpc.id


  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name = "aakulov-aws1-1"
  }
}

resource "aws_route_table" "aws1-2" {
  vpc_id = aws_vpc.vpc.id


  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name = "aakulov-aws1-2"
  }
}

resource "aws_route_table_association" "subnet1" {
  subnet_id      = aws_subnet.subnet1.id
  route_table_id = aws_route_table.aws1-1.id
}

resource "aws_route_table_association" "subnet2" {
  subnet_id      = aws_subnet.subnet2.id
  route_table_id = aws_route_table.aws1-2.id
}

resource "aws_security_group" "aakulov-aws1" {
  vpc_id = aws_vpc.vpc.id
  name   = "aakulov-aws1"
  tags = {
    Name = "aakulov-aws1"
  }

  ingress {
    from_port   = -1
    to_port     = -1
    protocol    = "icmp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_instance" "aws1" {
  ami                         = var.ami
  instance_type               = var.instance_type
  key_name                    = var.key_name
  vpc_security_group_ids      = [aws_security_group.aakulov-aws1.id]
  subnet_id                   = aws_subnet.subnet1.id
  associate_public_ip_address = true
  user_data                   = file("scripts/install_nginx.sh")
  tags = {
    Name = "aakulov-aws1"
  }
}

resource "aws_route53_record" "aws1" {
  zone_id         = "Z077919913NMEBCGB4WS0"
  name            = "tfe3.anton.hashicorp-success.com"
  type            = "CNAME"
  ttl             = "300"
  records         = [aws_lb.aws1.dns_name]
  allow_overwrite = true
}

resource "aws_route53_record" "cert_validation" {
  for_each = {
    for dvo in aws_acm_certificate.aws1.domain_validation_options : dvo.domain_name => {
      name   = dvo.resource_record_name
      record = dvo.resource_record_value
      type   = dvo.resource_record_type
    }
  }
  zone_id         = "Z077919913NMEBCGB4WS0"
  ttl             = 60
  type            = each.value.type
  name            = each.value.name
  records         = [each.value.record]
  allow_overwrite = true
}

resource "aws_acm_certificate" "aws1" {
  domain_name       = "tfe3.anton.hashicorp-success.com"
  validation_method = "DNS"

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_acm_certificate_validation" "aws1" {
  certificate_arn = aws_acm_certificate.aws1.arn
}

resource "aws_lb_target_group" "aakulov-aws1" {
  name        = "aakulov-aws1"
  port        = 80
  protocol    = "HTTP"
  vpc_id      = aws_vpc.vpc.id
  target_type = "instance"
}

resource "aws_lb_target_group_attachment" "aakulov-aws1" {
  target_group_arn = aws_lb_target_group.aakulov-aws1.arn
  target_id        = aws_instance.aws1.id
  depends_on       = [aws_instance.aws1]
}

resource "aws_lb" "aws1" {
  name               = "aakulov-aws1"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.aakulov-aws1.id]
  subnets            = [aws_subnet.subnet1.id, aws_subnet.subnet2.id]

  enable_deletion_protection = false
}

resource "aws_lb_listener" "aws1" {
  load_balancer_arn = aws_lb.aws1.arn
  port              = "443"
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-2016-08"
  certificate_arn   = aws_acm_certificate_validation.aws1.certificate_arn
  depends_on        = [aws_acm_certificate.aws1]
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.aakulov-aws1.arn
  }
}

output "ec2_instance_public_ip" {
  value = aws_instance.aws1.public_ip
}

output "aws_load_balancer_url" {
  value = aws_lb.aws1.dns_name
}

output "aws_url" {
  value = aws_route53_record.aws1.name
}
