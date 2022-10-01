# CRD Ref: https://prometheus-operator.dev/docs/operator/api/#monitoring.coreos.com/v1.PodMonitor
resource "kubernetes_manifest" "traefik_pod_monitor" {
  manifest = {
    apiVersion = "monitoring.coreos.com/v1"
    kind       = "PodMonitor"
    metadata = {
      name      = "traefik"
      namespace = var.namespace
      labels = {
        "release" = helm_release.kube-prometheus-stack.name
      }
    }
    spec = {
      podMetricsEndpoints = [{
        port = "metrics"
        path = "/metrics"
      }]
      namespaceSelector = {
        matchNames = ["kube-system"]
      }
      selector = {
        matchLabels = {
          "app.kubernetes.io/name" = "traefik"
        }
      }
    }
  }
}

resource "kubernetes_config_map" "traefik_dashboard" {
  metadata {
    name      = "traefik-dashboard"
    namespace = var.namespace
    labels = {
      grafana_dashboard = 1
    }
  }

  data = {
    "traefik-2_rev1.json" = file("${path.module}/dashboards/traefik-2_rev1.json")
  }
}
