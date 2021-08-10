variable "aws_profile" {
  description = "Enter AWS profile"
  type        = string
}

variable "region" {
  description = "Enter AWS region"
  type        = string
}

variable "k8s_cluster_name" {
  description = "Enter Kubernetes cluster name"
  type        = string
}

variable "aws_app_access_key" {
  description = "Enter AWS access key for application (it should have permissions to write to a S3 bucket)"
  type        = string
}

variable "aws_app_access_token" {
  description = "Enter AWS access token for application (it should have permissions to write to a S3 bucket)"
  type        = string
}

variable "training_suffix" {
  description = "Enter same training suffix that was used in the infra"
  type        = string
}