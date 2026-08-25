data "proxmox_version" "test" {}

resource "proxmox_virtual_environment_file" "image" {
  content_type = "import"
  datastore_id = "local"
  node_name    = var.proxmox_node_name

  source_file {
    path      = "https://cloud.debian.org/images/cloud/bookworm/latest/debian-12-genericcloud-amd64.qcow2"
    file_name = "debian-12.qcow2"
  }
}

resource "proxmox_virtual_environment_vm" "vm" {
  name            = "debian-12"
  node_name       = var.proxmox_node_name
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
    import_from  = proxmox_virtual_environment_file.image.id
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
