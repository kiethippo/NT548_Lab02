module "vpc" {
  source      = "./modules/vpc"
  cidr_block  = "10.0.0.0/16"
  project_tag = var.project_name
}

module "subnets" {
  source              = "./modules/subnets"
  vpc_id              = module.vpc.vpc_id
  public_cidr_blocks  = ["10.0.1.0/24"]
  private_cidr_blocks = ["10.0.2.0/24"]
  az                  = "${var.aws_region}a"
}

module "igw" {
  source      = "./modules/igw"
  vpc_id      = module.vpc.vpc_id
  project_tag = var.project_name
}

module "nat" {
  source           = "./modules/nat"
  public_subnet_id = module.subnets.public_subnet_ids[0]
  depends_on       = [module.igw]
}

module "route_tables" {
  source             = "./modules/route-tables"
  vpc_id             = module.vpc.vpc_id
  igw_id             = module.igw.igw_id
  nat_gateway_id     = module.nat.nat_gateway_id
  public_subnet_ids  = module.subnets.public_subnet_ids
  private_subnet_ids = module.subnets.private_subnet_ids
}

module "security_groups" {
  source     = "./modules/security-groups"
  vpc_id     = module.vpc.vpc_id
  my_ip_cidr = var.my_ip_cidr
}

module "ec2" {
  source            = "./modules/ec2"
  public_subnet_id  = module.subnets.public_subnet_ids[0]
  private_subnet_id = module.subnets.private_subnet_ids[0]
  public_sg_id      = module.security_groups.public_sg_id
  private_sg_id     = module.security_groups.private_sg_id
  key_name          = var.key_name
  project_tag       = var.project_name
}
