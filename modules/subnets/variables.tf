variable "vpc_id" {}
variable "public_cidr_blocks" {
  type = list(string)
}
variable "private_cidr_blocks" {
  type = list(string)
}
variable "az" {}
