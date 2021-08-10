resource "kubernetes_secret" "aws_s3_user_credentials" {
  metadata {
    name      = "aws-s3-user-creds"
    namespace = kubernetes_namespace.application.id
  }

  data = {
    aws_app_access_key   = var.aws_app_access_key
    aws_app_access_token = var.aws_app_access_token
  }
}