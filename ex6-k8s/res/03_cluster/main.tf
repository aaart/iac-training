resource "kubernetes_namespace" "argo" {
  metadata {
    name              = "argo"
  }
}

resource "helm_release" "ingress" {
  depends_on = [
    kubernetes_namespace.argo
  ]

  name                = "helm-ingress"
  repository          = "https://kubernetes.github.io/ingress-nginx"
  chart               = "ingress-nginx"
  namespace           = kubernetes_namespace.argo.metadata[0].name

}

resource "helm_release" "argo" {
  depends_on = [
    kubernetes_namespace.argo,
    helm_release.ingress
  ]

  name                = "helm-argo"
  repository          = "https://argoproj.github.io/argo-helm"
  chart               = "argo-cd"
  namespace           = kubernetes_namespace.argo.metadata[0].name
}

resource "kubernetes_ingress_v1" "argo-ingress" {
  depends_on = [
    helm_release.argo
  ]

  metadata {
    name      = "argo-ingress"
    namespace = kubernetes_namespace.argo.metadata[0].name
  }

  spec {
    rule {
      host = "argo.${var.cluster_full_name}"
      http {
        path {
          path = "/"
          backend {
            service {
              name = "argo-cd-server"
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

resource "kubernetes_service" "argo-service" {
  metadata {
    name      = "argo-cd-server"
    namespace = kubernetes_namespace.argo.metadata[0].name
  }

  spec {
    type = "LoadBalancer"
    selector = {
      name = "argo-cd-server"
    }
    session_affinity = "ClientIP"
    port {
      name = "http"
      port = 80
      target_port = 80
      protocol = "TCP"
    }
    port {
      name = "https"
      port = 443
      target_port = 443
      protocol = "TCP"
    }
  }
}