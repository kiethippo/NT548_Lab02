output "vpc_id" {
  value = module.vpc.vpc_id
}

output "public_subnets" {
  value = module.subnets.public_subnet_ids
}

output "public_ec2_ip" {
  value = module.ec2.public_ec2_ip
}
