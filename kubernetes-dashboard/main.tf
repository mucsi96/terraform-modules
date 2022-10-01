resource "helm_release" "kubernetes-dashboard" {
  name             = "kubernetes-dashboard"
  namespace        = "kubernetes-dashboard"
  create_namespace = true
  chart            = "kubernetes-dashboard"
  repository       = "https://kubernetes.github.io/dashboard"
  version          = "5.10.0"

  set {
    name  = "metricsScraper.enabled"
    value = "true"
  }

  set {
    name  = "protocolHttp"
    value = "true"
  }

  set {
    name  = "extraArgs"
    value = "{--enable-skip-login, --enable-insecure-login}"
  }
}

resource "kubernetes_cluster_role_binding" "kubernetes-dashboard" {
  metadata {
    name = "kubernetes-dashboard"
  }
  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "ClusterRole"
    name      = "cluster-admin"
  }
  subject {
    kind      = "ServiceAccount"
    name      = "kubernetes-dashboard"
    namespace = "kubernetes-dashboard"
  }
}
