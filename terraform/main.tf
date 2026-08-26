module "debian_image" {
  source       = "./modules/files/"
  node_name    = var.node_name
  content_type = "import"
  file_source  = "https://cloud.debian.org/images/cloud/bookworm/latest/debian-12-genericcloud-amd64.qcow2"
  file_name    = "debian-12.qcow2"
}

module "debian_vm" {
  depends_on = [module.debian_image]
  source     = "./modules/vm/"
  node_name  = var.node_name
  vm_name    = "debian"
  image_id   = module.debian_image.id
}
