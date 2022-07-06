provider "kubernetes" {
  config_path    = "~/.kube/config"
  config_context = "minikube"
}

resource "kubernetes_namespace" "tools" {
  metadata {
    name = "tools"
  }
}
resource "kubernetes_namespace" "dev" {
  metadata {
    name = "dev"
  }
}
