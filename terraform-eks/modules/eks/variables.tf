variable "cluster_name" {
  description = "EKS cluster name"
  type        = string
}

variable "kubernetes_version" {
  description = "Kubernetes version"
  type        = string
}

variable "vpc_id" {
  description = "VPC ID for the EKS cluster"
  type        = string
}

variable "private_subnet_ids" {
  description = "Private subnet IDs for EKS"
  type        = list(string)
}

variable "node_instance_types" {
  description = "EC2 instance types for the managed node group"
  type        = list(string)
}

variable "node_min_size" {
  description = "Minimum node count"
  type        = number
}

variable "node_desired_size" {
  description = "Desired node count"
  type        = number
}

variable "node_max_size" {
  description = "Maximum node count"
  type        = number
}

variable "project_name" {
  description = "Project name"
  type        = string
}
