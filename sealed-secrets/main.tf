resource "helm_release" "sealed-secrets" {
  name       = "sealed-secrets"
  namespace  = "kube-system"
  chart      = "sealed-secrets"
  repository = "https://bitnami-labs.github.io/sealed-secrets"
  version    = "2.6.4"

  set {
    name  = "fullnameOverride"
    value = "sealed-secrets-controller"
  }
}
