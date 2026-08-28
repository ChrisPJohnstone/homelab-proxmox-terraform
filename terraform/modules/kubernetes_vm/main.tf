module "network_config" {
  source       = "../files/"
  node_name    = var.node_name
  content_type = "snippets"
  file_name    = "${var.name}-network.yml"
  # TODO: Improve path
  source_raw = templatefile("../cloud-init/network.yml", {
    guest_network_interface = var.guest_network_interface
    guest_ip                = "${var.guest_ip}/${var.guest_subnet}"
    guest_gateway           = var.guest_gateway
    guest_dns_servers       = jsonencode(var.guest_dns_servers)
  })
}

module "vm" {
  depends_on = [
    module.network_config,
  ]
  source    = "../vm/"
  node_name = var.node_name
  vm_name   = var.name
  image_id  = var.debian_image_id
  initialization = {
    network_data_file_id = module.network_config.id
    user_data_file_id    = var.user_data_file_id
  }
}
