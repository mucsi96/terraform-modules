variable "namespace" {
  type = string
}

variable "tls_secret_name" {
  type    = string
  default = "app-tls-secret"
}

variable "hostname" {
  type = string
}

variable "client_host" {
  type = string
}

variable "server_host" {
  type = string
}

variable "certificate_issuer_server" {
  type    = string
  default = "https://acme-v02.api.letsencrypt.org/directory"
}

variable "certificate_issue_email" {
  type    = string
  default = "mucsi96@gmail.com"
}
