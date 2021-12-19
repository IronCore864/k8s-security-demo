resource "aws_security_group" "control_plane" {
  name        = "eks_cluster_${var.cluster_name}_control_plane_sg"
  description = "EKS cluster ${var.cluster_name} control plane security group."

  vpc_id = var.vpc_id

  tags = {
    "Name" = "eks_cluster_${var.cluster_name}_control_plane_sg"
  }
}

resource "aws_security_group_rule" "control_plane_egress" {
  description       = "Allow control plane egress access to the Internet."
  protocol          = "-1"
  security_group_id = aws_security_group.control_plane.id
  cidr_blocks       = ["0.0.0.0/0"]
  from_port         = 0
  to_port           = 0
  type              = "egress"
}

resource "aws_security_group_rule" "control_plane_api_server_ingress" {
  description              = "Allow pods to communicate with the EKS cluster API."
  protocol                 = "tcp"
  security_group_id        = aws_security_group.control_plane.id
  source_security_group_id = aws_security_group.worker.id
  from_port                = 443
  to_port                  = 443
  type                     = "ingress"
}

resource "aws_security_group_rule" "control_plane_etcd" {
  description              = "etcd server client API"
  protocol                 = "tcp"
  security_group_id        = aws_security_group.control_plane.id
  source_security_group_id = aws_security_group.control_plane.id
  from_port                = 2379
  to_port                  = 2380
  type                     = "ingress"
}

resource "aws_security_group_rule" "control_plane_scheduler" {
  description              = "kube-scheduler"
  protocol                 = "tcp"
  security_group_id        = aws_security_group.control_plane.id
  source_security_group_id = aws_security_group.control_plane.id
  from_port                = 10251
  to_port                  = 10251
  type                     = "ingress"
}

resource "aws_security_group_rule" "control_plane_controller_manager" {
  description              = "kube-controller-manager"
  protocol                 = "tcp"
  security_group_id        = aws_security_group.control_plane.id
  source_security_group_id = aws_security_group.control_plane.id
  from_port                = 10252
  to_port                  = 10252
  type                     = "ingress"
}

resource "aws_security_group_rule" "control_plane_cloud_controller_manager" {
  description              = "cloud-controller-manager"
  protocol                 = "tcp"
  security_group_id        = aws_security_group.control_plane.id
  source_security_group_id = aws_security_group.control_plane.id
  from_port                = 10258
  to_port                  = 10258
  type                     = "ingress"
}
