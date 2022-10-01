resource "kubernetes_config_map" "logs_dashboard" {
  metadata {
    name      = "logs-dashboard"
    namespace = var.namespace
    labels = {
      grafana_dashboard = 1
    }
  }

  data = {
    "logs.json" = file("${path.module}/dashboards/logs.json")
  }
}
