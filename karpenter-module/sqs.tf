resource "aws_sqs_queue" "karpenter_interruption_queue" {
  name = "karpenter-interruption-${var.cluster_name}"
}