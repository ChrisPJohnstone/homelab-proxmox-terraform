module "debian_image" {
  source       = "./modules/files/"
  node_name    = var.node_name
  content_type = "import"
  file_source  = "https://cloud.debian.org/images/cloud/bookworm/latest/debian-12-genericcloud-amd64.qcow2"
  file_name    = "debian-12.qcow2"
}

module "ssh_test_snippet" {
  source       = "./modules/files/"
  node_name    = var.node_name
  content_type = "snippets"
  datastore_id = "local"
  file_source  = "${path.module}/files/sftp-test.txt"
  file_name    = "sftp-test.txt"
}

module "kubernetes_control_planes" {
  depends_on = [module.debian_image]
  source     = "./modules/vm/"
  for_each   = var.kubernetes_control_planes
  node_name  = var.node_name
  vm_name    = each.key
  image_id   = module.debian_image.id
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
