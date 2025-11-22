
resource "aws_instance" "public" {
  ami                         = var.ami_id
  instance_type               = "t3.micro"
  subnet_id                   = var.public_subnet_id
  vpc_security_group_ids      = [var.public_sg_id]
  key_name                    = var.key_name
  associate_public_ip_address = true

  tags = {
    Name = "${var.project_tag}-public-ec2"
  }
}

resource "aws_instance" "private" {
  ami                    = var.ami_id
  instance_type          = "t3.micro"
  subnet_id              = var.private_subnet_id
  vpc_security_group_ids = [var.private_sg_id]
  key_name               = var.key_name

  tags = {
    Name = "${var.project_tag}-private-ec2"
  }
}

output "public_ec2_ip" {
  value = aws_instance.public.public_ip
}
