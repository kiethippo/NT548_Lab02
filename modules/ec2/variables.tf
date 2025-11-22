variable "public_subnet_id" {}
variable "private_subnet_id" {}
variable "public_sg_id" {}
variable "private_sg_id" {}
variable "key_name" {}
variable "project_tag" {}
variable "ami_id" {
  default = "ami-06b902272f32e4381"
}
