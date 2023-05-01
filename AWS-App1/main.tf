module "network" {
  source = "./network"
}

module "instances" {
  source = "./instances"
  vpc_id = module.network.vpc_id
  public_subnet_ids = module.network.public_subnet_ids
  private_subnet_ids = module.network.private_subnet_ids
}

module "lb" {
  source = "./lb"
  vpc_id = module.network.vpc_id
  public_subnet_ids = module.network.public_subnet_ids
  web_sg_id = module.instances.web_sg_id
}
