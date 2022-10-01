data "external" "version" {
  program     = ["bash", abspath("${path.module}/command.sh")]
  working_dir = var.path
  query = {
    tag_prefix = var.tag_prefix
  }
}
