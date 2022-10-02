variable "app_version" {
  type    = string
  default = ""
}

variable "path" {
  type = string
}

variable "tag_prefix" {
  type = string
}

variable "ignore" {
  type    = list(string)
  default = []
}
