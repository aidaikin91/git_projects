variable "cluster_name" {
    description = "EKS cluster name"
    type = string
}

variable "oidc_provider_arn" {
    description = "OIDC provider ARN for IRSA"
    type = string
}

variable "oidc_provider_url" {
    description = "OIDC provider URL"
    type = string
}

variable "enable_karpenter" {
    type = bool
    default = true
}