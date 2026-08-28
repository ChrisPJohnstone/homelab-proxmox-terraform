module "debian_image" {
  source       = "./modules/files/"
  node_name    = var.node_name
  content_type = "import"
  file_source  = "https://cloud.debian.org/images/cloud/bookworm/latest/debian-12-genericcloud-amd64.qcow2"
  file_name    = "debian-12.qcow2"
}

module "network_config" {
  source       = "./modules/files/"
  node_name    = var.node_name
  content_type = "snippets"
  file_source  = "../cloud-init/network.yml"
  file_name    = "network-config.yml"
}

module "kubernetes_control_planes" {
  depends_on = [
    module.debian_image,
    module.network_config,
  ]
  source    = "./modules/vm/"
  for_each  = var.kubernetes_control_planes
  node_name = var.node_name
  vm_name   = each.key
  image_id  = module.debian_image.id
  initialization = {
    network_data_file_id = module.network_config.id
  }
}

module "kubernetes_workers" {
  depends_on = [
    module.debian_image,
    module.kubernetes_control_planes,
  ]
  source    = "./modules/vm/"
  for_each  = var.kubernetes_workers
  node_name = var.node_name
  vm_name   = each.key
  image_id  = module.debian_image.id
}
