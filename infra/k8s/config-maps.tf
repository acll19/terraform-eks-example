data "aws_s3_bucket" "bucket" {
  bucket = "training-${var.training_suffix}"
}

resource "kubernetes_config_map" "app_config" {
  metadata {
    name = "app-config"
    namespace = kubernetes_namespace.application.id
  }

  data = {
    s3_bucket_name = data.aws_s3_bucket.bucket.id
  }
}