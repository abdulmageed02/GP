resource "kubernetes_pod_v1" "nexus_po" {
  metadata {
    name      = "nexus"
    namespace = "tools"
    labels = {

     app = "nexus"
     
    }
  }

  spec {
    init_container {
      name    = "volume-mount-hack"
      image   = "busybox"
      command = ["sh", "-c", "chown -R 200:200 /nexus-data"]
      volume_mount {
        name       = "nexus-data"
        mount_path = "/nexus-data"
      }

    }
    container {
      image = "sonatype/nexus3"
      name  = "nexus"

      port {
        container_port = 8081
      }
      port {
        container_port = 8082
      }

      volume_mount {
        name       = "nexus-data"
        mount_path = "/nexus-data"
      }

    }
    volume {
      name = "nexus-data"
      host_path {
        path = "/var/nexus-localdata333333"
      }
    }
  }
}
resource "kubernetes_service" "nexus_nodePort" {
  metadata {
    name      = "nexus-sv"
    namespace = "tools"
  }
  spec {
    selector = {
      app = "nexus"
    }
    type = "NodePort"
    port {
      node_port   = 30202
      port        = 8081
      target_port = 8081
    }
  }
}
resource "kubernetes_service" "nexus_clusterIp" {
  metadata {
    name      = "nexus-clusterip"
    namespace = "tools"
  }
  spec {
    selector = {
      app = "nexus"
    }
    port {
      port        = 8082
      target_port = 8082
    }
  }
}
