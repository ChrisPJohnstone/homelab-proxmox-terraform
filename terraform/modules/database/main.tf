module "network_config" {
  source       = "../files/"
  node_name    = var.node_name
  content_type = "snippets"
  file_name    = "database-network.yml"
  # TODO: Improve path
  source_raw = templatefile("../cloud-init/network.yml", {
    guest_network_interface = var.guest_network_interface
    guest_ip                = "${var.guest_ip}/${var.guest_subnet}"
    guest_gateway           = var.guest_gateway
    guest_dns_servers       = jsonencode(var.guest_dns_servers)
  })
}

module "user_config" {
  source       = "../files/"
  node_name    = var.node_name
  content_type = "snippets"
  file_name    = "database-user.yml"
  # TODO: Improve path
  source_raw = templatefile("../cloud-init/database-user-data.yml", {
    hostname       = var.hostname
    guest_username = var.guest_username
    ssh_public_key = file(var.ssh_public_key_file)
    guest_cidr     = local.guest_cidr
    admin_password = var.admin_password
  })
}

module "control_planes" {
  depends_on = [
    module.network_config,
    module.user_config,
  ]
  source    = "../vm/"
  node_name = var.node_name
  vm_name   = "database"
  image_id  = var.debian_image_id
  initialization = {
    network_data_file_id = module.network_config.id
    user_data_file_id    = module.user_config.id
  }
}
