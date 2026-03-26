variable "vpc_id" {
  type        = string
  description = "VPC ID where DocumentDB will be deployed"
}

variable "private_subnets" {
  type        = list(string)
  description = "Private subnet IDs for DocumentDB subnet group"
}

variable "environment" {
  type        = string
  description = "Environment name"
}

variable "project_name" {
  type        = string
  description = "Project name prefix"
}

variable "cluster_name" {
  type        = string
  description = "EKS cluster name or logical cluster name"
}

variable "db_name" {
  type        = string
  description = "DocumentDB database name"
}

variable "instance_class" {
  type        = string
  description = "DocumentDB instance class"
}

variable "instance_count" {
  type        = number
  description = "Number of DocumentDB instances"
}

variable "master_username" {
  type        = string
  description = "Master username for DocumentDB"
  default     = "proshopadmin"
}

variable "engine_version" {
  type        = string
  description = "DocumentDB engine version"
  default     = "5.0.0"
}

variable "port" {
  type        = number
  description = "DocumentDB port"
  default     = 27017
}

variable "allowed_cidr_blocks" {
  type        = list(string)
  description = "CIDR blocks allowed to reach DocumentDB"
  default     = []
}

variable "eks_node_security_group_id" {
  type        = string
  description = "Security group ID of EKS worker nodes"
}