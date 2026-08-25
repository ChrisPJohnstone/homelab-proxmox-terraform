data "proxmox_version" "test" {}

output "version" {
  value = {
    version = data.proxmox_version.test.version
  }
}
