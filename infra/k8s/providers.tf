provider "aws" {
  region = var.region
  shared_credentials_file = "../../tf_user/credentials"
  profile = var.aws_profile
}


data "aws_eks_cluster_auth" "k8s_cluster" {
  name = var.k8s_cluster_name
}

data "aws_eks_cluster" "k8s_cluster" {
  name = var.k8s_cluster_name
}

provider "kubernetes" {
  host                   = data.aws_eks_cluster.k8s_cluster.endpoint
  token                  = data.aws_eks_cluster_auth.k8s_cluster.token
  cluster_ca_certificate = base64decode(data.aws_eks_cluster.k8s_cluster.certificate_authority.0.data)
}