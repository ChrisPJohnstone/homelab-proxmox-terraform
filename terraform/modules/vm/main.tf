resource "proxmox_virtual_environment_vm" "vm" {
  name            = var.vm_name
  node_name       = var.node_name
  stop_on_destroy = true
  cpu {
    type  = var.cpu_type
    cores = var.cpu_cores
  }
  memory {
    dedicated = var.memory_dedicated
    floating  = var.memory_floating
    shared    = var.memory_shared
  }
  disk {
    datastore_id = var.datastore_id
    import_from  = var.image_id
    interface    = "scsi0"
    iothread     = true
    discard      = "on"
    size         = 40
  }
  scsi_hardware = "virtio-scsi-single"
  network_device {
    bridge = "vmbr0"
    model  = "virtio"
  }
  operating_system {
    type = "l26"
  }
  dynamic "initialization" {
    for_each = var.initialization == {} ? [] : [1]
    content {
      datastore_id         = coalesce(var.initialization.datastore_id, var.datastore_id)
      network_data_file_id = var.initialization.network_data_file_id
      user_data_file_id    = var.initialization.user_data_file_id
      vendor_data_file_id  = var.initialization.vendor_data_file_id
      meta_data_file_id    = var.initialization.meta_data_file_id
    }
  }
}
