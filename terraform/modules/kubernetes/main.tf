module "network_config" {
  source       = "../files/"
  count        = var.n_control_planes + var.n_workers
  node_name    = var.node_name
  content_type = "snippets"
  file_name    = "kubernetes-network-${count.index}.yml"
  # TODO: Improve path
  source_raw = templatefile("../cloud-init/network.yml", {
    guest_network_interface = var.guest_network_interface
    guest_ip                = "192.168.0.${count.index + var.start_ip}/${var.guest_subnet}"
    guest_gateway           = var.guest_gateway
    guest_dns_servers       = jsonencode(var.guest_dns_servers)
  })
}

module "control_planes" {
  depends_on = [
    module.network_config,
  ]
  source    = "../vm/"
  count     = var.n_control_planes
  node_name = var.node_name
  vm_name   = "gaffer-${count.index}"
  image_id  = var.debian_image_id
  initialization = {
    network_data_file_id = module.network_config[count.index].id
    user_data_file_id    = var.user_data_file_id
  }
}

module "workers" {
  depends_on = [
    module.network_config,
  ]
  source    = "../vm/"
  count     = var.n_workers
  node_name = var.node_name
  vm_name   = count.index % 2 == 0 ? "hoddit-${count.index / 2}" : "doddit-${(count.index - 1) / 2}"
  image_id  = var.debian_image_id
  initialization = {
    network_data_file_id = module.network_config[count.index + var.n_control_planes].id
    user_data_file_id    = var.user_data_file_id
  }
}
