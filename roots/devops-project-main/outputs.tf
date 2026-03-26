output "karpenter_controller_role_arn" {
  value = module.karpenter.karpenter_controller_role_arn
}

output "karpenter_node_role_name" {
  value = module.karpenter.karpenter_node_role_name
}

output "karpenter_instance_profile_name" {
  value = module.karpenter.karpenter_instance_profile_name
}

output "karpenter_interruption_queue_name" {
  value = module.karpenter.karpenter_interruption_queue_name
}