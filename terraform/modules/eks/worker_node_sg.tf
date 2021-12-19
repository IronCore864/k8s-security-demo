resource "aws_security_group" "worker" {
  name        = "eks_cluster_${var.cluster_name}_worker_sg"
  description = "Security group for all worker nodes in the cluster."

  vpc_id = var.vpc_id

  lifecycle {
    ignore_changes = [ingress]
  }

  tags = {
    "Name"                   = "eks_cluster_${var.cluster_name}_worker_sg"
    "kubernetes.io/cluster/" = var.cluster_name
  }
}
