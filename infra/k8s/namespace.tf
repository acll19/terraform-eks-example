resource "kubernetes_namespace" "application" {
  metadata {
    labels = {
      app = "training"
    }

    name = "application"
  }
}