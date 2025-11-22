# SG cho public EC2
resource "aws_security_group" "public_ec2" {
  name        = "public-ec2-sg"
  description = "Allow SSH from user IP"
  vpc_id      = var.vpc_id

  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [var.my_ip_cidr]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# SG cho private EC2
resource "aws_security_group" "private_ec2" {
  name        = "private-ec2-sg"
  description = "Allow SSH from public EC2 SG"
  vpc_id      = var.vpc_id

  ingress {
    description     = "SSH from public EC2"
    from_port       = 22
    to_port         = 22
    protocol        = "tcp"
    security_groups = [aws_security_group.public_ec2.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

output "public_sg_id" {
  value = aws_security_group.public_ec2.id
}

output "private_sg_id" {
  value = aws_security_group.private_ec2.id
}
