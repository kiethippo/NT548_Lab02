# Public subnets
resource "aws_subnet" "public" {
  count                   = length(var.public_cidr_blocks)
  vpc_id                  = var.vpc_id
  cidr_block              = var.public_cidr_blocks[count.index]
  availability_zone       = var.az
  map_public_ip_on_launch = true

  tags = {
    Name = "public-${count.index}"
  }
}

# Private subnets
resource "aws_subnet" "private" {
  count             = length(var.private_cidr_blocks)
  vpc_id            = var.vpc_id
  cidr_block        = var.private_cidr_blocks[count.index]
  availability_zone = var.az

  tags = {
    Name = "private-${count.index}"
  }
}

output "public_subnet_ids" {
  value = [for s in aws_subnet.public : s.id]
}

output "private_subnet_ids" {
  value = [for s in aws_subnet.private : s.id]
}
