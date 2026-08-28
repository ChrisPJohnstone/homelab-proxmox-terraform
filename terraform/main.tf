module "debian_image" {
  source       = "./modules/files/"
  node_name    = var.node_name
  content_type = "import"
  file_name    = "debian-12.qcow2"
  source_file  = "https://cloud.debian.org/images/cloud/bookworm/latest/debian-12-genericcloud-amd64.qcow2"
}

module "kubernetes" {
  depends_on          = [module.debian_image]
  source              = "./modules/kubernetes"
  node_name           = var.node_name
  debian_image_id     = module.debian_image.id
  ssh_public_key_file = var.ssh_public_key_file
  guest_username      = "chris"
  n_control_planes    = 1
  n_workers           = 2
}
