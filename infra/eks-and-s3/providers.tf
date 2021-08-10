# Configure the AWS Provider using Shared Credentials File 
# https://registry.terraform.io/providers/hashicorp/aws/latest/docs#shared-credentials-file
provider "aws" {
  region = var.region
  shared_credentials_file = "../../tf_user/credentials"
  profile = var.aws_profile
}


# The Kubernetes provider is included in this file so the EKS module can complete successfully. 
# Otherwise, it throws an error when creating `kubernetes_config_map.aws_auth`.
# You should **not** schedule deployments and services in this workspace. 
# This keeps workspaces modular (one for provision EKS, another for scheduling Kubernetes resources) as per best practices.
provider "kubernetes" {
  host                   = data.aws_eks_cluster.cluster.endpoint
  token                  = data.aws_eks_cluster_auth.cluster.token
  cluster_ca_certificate = base64decode(data.aws_eks_cluster.cluster.certificate_authority.0.data)
}

