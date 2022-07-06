resource "kubernetes_service_account_v1" "jenkins_sa" {
  metadata {
    name      = "jenkins-sa"
    namespace = kubernetes_namespace.tools.metadata.0.name
  }
  secret {
    name = kubernetes_secret_v1.jenkins_sa_sec.metadata.0.name
  }
}

resource "kubernetes_secret_v1" "jenkins_sa_sec" {
  metadata {
    name      = "jenkins-sec"
    namespace = kubernetes_namespace.tools.metadata.0.name
  }
}

resource "kubernetes_role_v1" "sa_role" {
metadata {
    name = "jenkins_sa_role"
    namespace = kubernetes_namespace.dev.metadata.0.name
    labels = {
        name = "jenkins_sa_role"
    }
}
rule {
api_groups = [""]
resources = ["pods","services","configmaps", "secrets"]
verbs = ["*"]
}
rule {
api_groups = ["apps"]
resources = ["deployments"]
verbs = ["*"]
}
}

resource "kubernetes_role_binding" "jenkins_sa_rb" {
  metadata {
    name      = "jenkins_sa_rb"
    namespace = kubernetes_namespace.dev.metadata.0.name
  }
  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "Role"
    name      = kubernetes_role_v1.sa_role.metadata.0.name
  }
 
    subject {
        kind      = "ServiceAccount"
        name      = kubernetes_service_account_v1.jenkins_sa.metadata.0.name
        namespace = kubernetes_namespace.tools.metadata.0.name
    }
}
