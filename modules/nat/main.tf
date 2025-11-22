# tạo EIP cho NAT
resource "aws_eip" "nat" {
  domain = "vpc"
}

resource "aws_nat_gateway" "this" {
  allocation_id = aws_eip.nat.id
  subnet_id     = var.public_subnet_id

  tags = {
    Name = "nat-gw"
  }
}

output "nat_gateway_id" {
  value = aws_nat_gateway.this.id
}
