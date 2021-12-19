module "eks" {
  source = "./modules/eks"

  vpc_id       = var.vpc_id
  cluster_name = "test"
}
