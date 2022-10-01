# CRD Ref: https://prometheus-operator.dev/docs/operator/api/#monitoring.coreos.com/v1.ServiceMonitor
resource "kubernetes_manifest" "spring_boot_service_monitor" {
  manifest = {
    apiVersion = "monitoring.coreos.com/v1"
    kind       = "ServiceMonitor"
    metadata = {
      name      = "spring-boot"
      namespace = var.namespace
      labels = {
        "release" = helm_release.kube-prometheus-stack.name
      }
    }
    spec = {
      endpoints = [{
        port = "management"
        path = "/actuator/prometheus"
      }]
      namespaceSelector = {
        matchNames = [var.scrape_namespace]
      }
      selector = {
        matchLabels = {
          scrape : "spring-boot"
        }
      }
    }
  }
}

resource "kubernetes_config_map" "jvm-micrometer_dashboard" {
  metadata {
    name      = "jvm-micrometer-dashboard"
    namespace = var.namespace
    labels = {
      grafana_dashboard = 1
    }
  }

  data = {
    "jvm-micrometer_rev1.json" = file("${path.module}/dashboards/jvm-micrometer_rev1.json")
  }
}
