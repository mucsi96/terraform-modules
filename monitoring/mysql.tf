# CRD Ref: https://prometheus-operator.dev/docs/operator/api/#monitoring.coreos.com/v1.ServiceMonitor
resource "kubernetes_manifest" "mysql_service_monitor" {
  manifest = {
    apiVersion = "monitoring.coreos.com/v1"
    kind       = "ServiceMonitor"
    metadata = {
      name      = "mysql"
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
          scrape = "mysql"
        }
      }
    }
  }
}

resource "kubernetes_config_map" "mysql_dashboard" {
  metadata {
    name      = "mysql-dashboard"
    namespace = var.namespace
    labels = {
      grafana_dashboard = 1
    }
  }

  data = {
    "mysql-overview_rev1.json" = file("${path.module}/dashboards/mysql-overview_rev1.json")
  }
}
