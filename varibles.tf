variable "aws_region" {
  description = "AWS region to deploy"
  type        = string
  default     = "ap-southeast-1"
}

variable "project_name" {
  description = "Tag prefix"
  type        = string
  default     = "nt548-tf-lab02"
}

variable "my_ip_cidr" {
  description = "Your public IP to ssh, in CIDR"
  type        = string
  default     = "0.0.0.0/0"
}

variable "key_name" {
  description = "Existing AWS key pair name"
  type        = string
  default     = "keypair_lab2"
}
