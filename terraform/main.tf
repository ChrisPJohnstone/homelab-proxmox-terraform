module "debian_image" {
  source       = "./modules/files/"
  node_name    = var.node_name
  content_type = "import"
  file_source  = "https://cloud.debian.org/images/cloud/bookworm/latest/debian-12-genericcloud-amd64.qcow2"
  file_name    = "debian-12.qcow2"
}

resource "proxmox_virtual_environment_vm" "vm" {
  depends_on      = [module.debian_image]
  name            = "debian-12"
  node_name       = var.node_name
  stop_on_destroy = true
  cpu {
    cores = 2
    type  = "x86-64-v2-AES"
  }
  memory {
    dedicated = 4096
  }
  disk {
    datastore_id = "local-zfs"
    import_from  = module.debian_image.id
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
