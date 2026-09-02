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
  guest_username      = "chris"
  ssh_public_key_file = var.ssh_public_key_file
  kubernetes_version  = "v1.36"
  n_control_planes    = 1
  n_workers           = 2
}

module "database" {
  depends_on          = [module.debian_image]
  source              = "./modules/database/"
  node_name           = var.node_name
  debian_image_id     = module.debian_image.id
  guest_username      = "chris"
  ssh_public_key_file = var.ssh_public_key_file
  guest_ip            = "192.168.0.149"
  admin_password      = var.postgres_admin_password
}
