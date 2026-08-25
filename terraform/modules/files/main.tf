resource "proxmox_virtual_environment_file" "image" {
  node_name    = var.node_name
  datastore_id = var.datastore_id
  content_type = var.content_type
  source_file {
    path      = var.file_source
    file_name = var.file_name
  }
}
