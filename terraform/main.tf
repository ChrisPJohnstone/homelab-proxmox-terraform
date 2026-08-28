module "debian_image" {
  source       = "./modules/files/"
  node_name    = var.node_name
  content_type = "import"
  file_name    = "debian-12.qcow2"
  source_file  = "https://cloud.debian.org/images/cloud/bookworm/latest/debian-12-genericcloud-amd64.qcow2"
}

module "user_config" {
  source       = "./modules/files/"
  node_name    = var.node_name
  content_type = "snippets"
  file_name    = "user-data.yml"
  # TODO: Improve path
  source_raw = templatefile("../cloud-init/user-data.yml", {
    guest_username = var.ssh_username
    ssh_public_key = file(var.ssh_public_key_file)
  })
}

module "kubernetes_control_planes" {
  depends_on = [
    module.debian_image,
    module.user_config,
  ]
  source            = "./modules/kubernetes_vm"
  count             = var.n_kubernetes_control_planes
  node_name         = var.node_name
  name              = "gaffer-${count.index}"
  debian_image_id   = module.debian_image.id
  user_data_file_id = module.user_config.id
  guest_ip          = "192.168.0.${count.index + var.kubernetes_start_ip}"
}

module "kubernetes_workers" {
  depends_on = [
    module.debian_image,
    module.user_config,
    module.kubernetes_control_planes,
  ]
  source            = "./modules/kubernetes_vm"
  count             = var.n_kubernetes_workers
  node_name         = var.node_name
  name              = count.index % 2 == 0 ? "hoddit-${count.index / 2}" : "doddit-${(count.index - 1) / 2}"
  debian_image_id   = module.debian_image.id
  user_data_file_id = module.user_config.id
  guest_ip          = "192.168.0.${count.index + var.kubernetes_start_ip + var.n_kubernetes_control_planes}"
}
