module "network" {
  source = "./modules/networking"
  
  vpc_name        = "main"
  vpc_cidr_block  = "10.0.0.0/16"

  public_subnets  = {
    "ap-southeast-1a" = "10.0.1.0/24"
    "ap-southeast-1b" = "10.0.2.0/24"
    "ap-southeast-1c" = "10.0.3.0/24"
  }

  private_subnets = {
    "ap-southeast-1a" = "10.0.11.0/24"
    "ap-southeast-1b" = "10.0.12.0/24"
    "ap-southeast-1c" = "10.0.13.0/24"
  }
}

module "cluster" {
  source = "./modules/eks"

  cluster_name      = "test"
  nodegroup_name    = "test"
  vpc_id            = module.network.vpc_id
  worker_subnet_ids = module.network.private_subnet_ids
}
