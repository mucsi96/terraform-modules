# CRD Ref: https://prometheus-operator.dev/docs/operator/api/#monitoring.coreos.com/v1.ServiceMonitor
resource "kubernetes_manifest" "nginx_service_monitor" {
  manifest = {
    apiVersion = "monitoring.coreos.com/v1"
    kind       = "ServiceMonitor"
    metadata = {
      name      = "nginx"
      namespace = var.namespace
      labels = {
        "release" = helm_release.kube-prometheus-stack.name
      }
    }
    spec = {
      endpoints = [{
        port = "metrics"
        path = "/metrics"
      }]
      namespaceSelector = {
        matchNames = [var.scrape_namespace]
      }
      selector = {
        matchLabels = {
          scrape = "nginx"
        }
      }
    }
  }
}

resource "kubernetes_config_map" "nginx_dashboard" {
  metadata {
    name      = "nginx-dashboard"
    namespace = var.namespace
    labels = {
      grafana_dashboard = 1
    }
  }

  data = {
    "nginx_rev1.json" = file("${path.module}/dashboards/nginx_rev1.json")
  }
}
