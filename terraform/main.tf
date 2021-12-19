module "eks" {
  source = "./modules/eks"

  vpc_id       = var.vpc_id
  cluster_name = "test"
}

module "self-managed" {
  source = "./modules/k8s-self-managed"

  vpc_id       = var.vpc_id
  cluster_name = "self_managed"
}
