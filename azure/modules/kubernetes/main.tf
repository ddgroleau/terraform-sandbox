locals {
  deployment_name = "hello-world"
}

# Deployment: Simple HTTP server to test network configuration
resource "kubernetes_deployment_v1" "http-server" {
  metadata {
    name = local.deployment_name
  }

  spec {
    replicas = 1

    selector {
      match_labels = { app = local.deployment_name }
    }

    template {
      metadata {
        labels = { app = local.deployment_name }
      }
      spec {
        container {
          name  = "http-echo"
          image = "hashicorp/http-echo:1.0.0"
          args = [
            "-text=Hello from Azure Kubernetes Service!",
            "-listen=:8080"
          ]
          port {
            container_port = 8080
          }
        }
      }
    }
  }
}

# Service Resource to expose deployment internally
resource "kubernetes_service_v1" "http-server" {
  metadata {
    name = local.deployment_name
  }

  spec {
    selector = { app = local.deployment_name }
    port {
      port        = 80
      target_port = 8080
    }
  }
}

# Ingress Resource to expose service via Application Gateway Ingress Controller
resource "kubernetes_ingress_v1" "http-server" {
  metadata {
    name = local.deployment_name
  }

  spec {
    ingress_class_name = "azure-application-gateway"

    rule {
      http {
        path {
          path      = "/*"
          path_type = "Prefix"
          backend {
            service {
              name = kubernetes_service_v1.http-server.metadata[0].name
              port {
                number = 80
              }
            }
          }
        }
      }
    }
  }
}
