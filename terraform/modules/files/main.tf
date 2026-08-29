resource "proxmox_virtual_environment_file" "image" {
  node_name    = var.node_name
  datastore_id = var.datastore_id
  content_type = var.content_type
  # TODO: Validate only one source provided
  dynamic "source_file" {
    for_each = var.source_file != null ? [1] : []
    content {
      path      = var.source_file
      file_name = var.file_name
    }
  }
  dynamic "source_raw" {
    for_each = var.source_raw != null ? [1] : []
    content {
      data      = var.source_raw
      file_name = var.file_name
    }
  }
}
