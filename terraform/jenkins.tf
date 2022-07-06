resource "kubernetes_pod_v1" "jenkins_po" {
  metadata {
    name      = "jenkins"
    namespace = "tools"
    labels = {
      app = "jenkins"

    }
  }
 spec {
    service_account_name = kubernetes_service_account_v1.jenkins_sa.metadata.0.name
    init_container {
                name = "volume-mount-hack"
                image = "busybox"
                command = ["sh", "-c", "chmod 777 /var/jenkins_home"]
                volume_mount {
                            name       = "jenkins-data"
                            mount_path = "/var/jenkins_home"
                             }

        }
    container {
      image = "mohamedalaa44/jenkins-docker-3"
      name  = "jenkins"

      port {
        container_port = 8080
      }

      volume_mount {
        name       = "docker"
        mount_path = "/var/run/docker.sock"
      }

      volume_mount {
        name       = "jenkins-data"
        mount_path = "/var/jenkins_home"
      }

    }
    volume {
      name = "docker"
      host_path {
        path = "/var/run/docker.sock"
      }
    }
    volume {
      name = "jenkins-data"
      host_path {
        path = "/var/jenkins_data"
      }
    }
  }
}
resource "kubernetes_service" "jenkins_nodePort" {
  metadata {
    name      = "jenkins-sv"
    namespace = "tools"
  }
  spec {
    selector = {
      app = "jenkins"
    }
    type = "NodePort"
    port {
      node_port   = 30201
      port        = 8080
      target_port = 8080
    }
  }
}
