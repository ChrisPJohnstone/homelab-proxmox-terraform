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
}
