module "chart_version" {
  source     = "../helm-chart-version"
  tag_prefix = "ingress-chart"
  path       = path.module
}

resource "helm_release" "chart" {
  name      = "app-ingress"
  version   = module.chart_version.version
  namespace = var.namespace
  chart     = path.module

  set {
    name  = "hostName"
    value = var.hostname
  }

  set {
    name  = "clientHost"
    value = var.client_host
  }

  set {
    name  = "serverHost"
    value = var.server_host
  }

  set {
    name  = "tlsSecretName"
    value = var.tls_secret_name
  }
}

# CRD Ref: https://cert-manager.io/docs/reference/api-docs/#cert-manager.io/v1.Certificate
resource "kubernetes_manifest" "tls_certificate" {
  manifest = {
    apiVersion = "cert-manager.io/v1"
    kind       = "Certificate"
    metadata = {
      name      = "tls-certificate"
      namespace = var.namespace
    }
    spec = {
      secretName = var.tls_secret_name
      issuerRef = {
        name = var.issuer_name
        kind = "ClusterIssuer"
      }
      dnsNames = [var.hostname]
    }
  }
}
