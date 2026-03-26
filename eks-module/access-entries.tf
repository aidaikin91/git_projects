resource "aws_eks_access_entry" "nodes_entry" {
  cluster_name  = aws_eks_cluster.projectx_cluster.name
  principal_arn = aws_iam_role.workers_role.arn
  type          = "EC2_LINUX"
}

resource "aws_eks_access_entry" "aidai25b" {
  cluster_name  = aws_eks_cluster.projectx_cluster.name
  principal_arn = "arn:aws:iam::060623762260:user/aidai25b"
  type          = "STANDARD"
}

resource "aws_eks_access_policy_association" "aidai25b_cluster_admin" {
  cluster_name  = aws_eks_cluster.projectx_cluster.name
  principal_arn = "arn:aws:iam::060623762260:user/aidai25b"
  policy_arn    = "arn:aws:eks::aws:cluster-access-policy/AmazonEKSClusterAdminPolicy"

  access_scope { type = "cluster" }

  depends_on = [aws_eks_access_entry.aidai25b]
}
