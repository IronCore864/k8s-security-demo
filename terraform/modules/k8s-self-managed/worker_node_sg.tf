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

resource "aws_security_group_rule" "workers_egress" {
  description       = "Allow worker nodes egress access to the Internet."
  protocol          = "-1"
  security_group_id = aws_security_group.worker.id
  cidr_blocks       = ["0.0.0.0/0"]
  from_port         = 0
  to_port           = 0
  type              = "egress"
}

resource "aws_security_group_rule" "worker_kubelet_api" {
  description              = "kubelet API"
  protocol                 = "tcp"
  security_group_id        = aws_security_group.worker.id
  source_security_group_id = aws_security_group.control_plane.id
  from_port                = 10250
  to_port                  = 10250
  type                     = "ingress"
}

resource "aws_security_group_rule" "cluster_worker_ingress" {
  description              = "NodePort Services"
  protocol                 = "tcp"
  security_group_id        = aws_security_group.worker.id
  source_security_group_id = aws_security_group.control_plane.id
  from_port                = 30000
  to_port                  = 32767
  type                     = "ingress"
}

resource "aws_security_group_rule" "worker_node_ports" {
  description              = "Allow node to communicate with each other."
  protocol                 = "-1"
  security_group_id        = aws_security_group.worker.id
  source_security_group_id = aws_security_group.worker.id
  from_port                = 30000
  to_port                  = 32767
  type                     = "ingress"
}
