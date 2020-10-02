provider "kubernetes" {
  load_config_file = "false"
}

resource "null_resource" "example" {}


# resource "kubernetes_deployment" "pod_info" {
#     # stefanprodan/podinfo
# }

resource "kubernetes_pod" "pod_info" {
  metadata {
    name = "pod-info"
    labels = {
      app = "podinfo"
    }
  }

  spec {
    container {
      image = "stefanprodan/podinfo"
      name  = "example"

      port {
        container_port = 9898
      }
    }
  }
}

resource "kubernetes_service" "pod_info" {
  metadata {
    name = "pod-info"
  }
  spec {
    selector = {
      app = kubernetes_pod.pod_info.metadata[0].labels.app
    }
    port {
      port        = 9898
      target_port = 9898
    }

    type = "LoadBalancer"
  }
}

output "lb_ip" {
  value = kubernetes_service.pod_info.load_balancer_ingress[0].ip
}