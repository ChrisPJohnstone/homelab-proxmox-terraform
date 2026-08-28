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

module "kubernetes" {
  depends_on = [
    module.debian_image,
    module.user_config,
  ]
  source            = "./modules/kubernetes"
  node_name         = var.node_name
  debian_image_id   = module.debian_image.id
  user_data_file_id = module.user_config.id
  n_control_planes  = 1
  n_workers         = 2
}
