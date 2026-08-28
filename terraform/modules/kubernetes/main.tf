module "network_config" {
  source       = "../files/"
  count        = var.n_control_planes + var.n_workers
  node_name    = var.node_name
  content_type = "snippets"
  file_name    = "kubernetes-network-${count.index}.yml"
  # TODO: Improve path
  source_raw = templatefile("../cloud-init/network.yml", {
    guest_network_interface = var.guest_network_interface
    guest_ip                = "${var.ip_prefix}.${count.index + var.start_ip}/${var.guest_subnet}"
    guest_gateway           = var.guest_gateway
    guest_dns_servers       = jsonencode(var.guest_dns_servers)
  })
}

# TODO: Fix hostname
module "first_node_user_config" {
  source       = "../files/"
  node_name    = var.node_name
  content_type = "snippets"
  file_name    = "kubernetes-control-plane-user-data.yml"
  # TODO: Improve path
  source_raw = templatefile("../cloud-init/kubernetes-user-data.yml", {
    guest_username = var.guest_username
    ssh_public_key = file(var.ssh_public_key_file)
    is_first_node  = true
    apt_key_dir    = var.apt_key_dir
  })
}

module "user_config" {
  source       = "../files/"
  node_name    = var.node_name
  content_type = "snippets"
  file_name    = "kubernetes-worker-user-data.yml"
  # TODO: Improve path
  source_raw = templatefile("../cloud-init/kubernetes-user-data.yml", {
    guest_username = var.guest_username
    ssh_public_key = file(var.ssh_public_key_file)
    is_first_node  = false
    apt_key_dir    = var.apt_key_dir
  })
}

module "control_planes" {
  depends_on = [
    module.network_config,
    module.first_node_user_config,
    module.user_config,
  ]
  source    = "../vm/"
  count     = var.n_control_planes
  node_name = var.node_name
  vm_name   = "gaffer-${count.index}"
  image_id  = var.debian_image_id
  initialization = {
    network_data_file_id = module.network_config[count.index].id
    user_data_file_id    = count.index == 0 ? module.first_node_user_config.id : module.user_config.id
  }
}

module "workers" {
  depends_on = [
    module.network_config,
    module.user_config,
  ]
  source    = "../vm/"
  count     = var.n_workers
  node_name = var.node_name
  vm_name   = count.index % 2 == 0 ? "hoddit-${count.index / 2}" : "doddit-${(count.index - 1) / 2}"
  image_id  = var.debian_image_id
  initialization = {
    network_data_file_id = module.network_config[count.index + var.n_control_planes].id
    user_data_file_id    = module.user_config.id
  }
}

resource "null_resource" "wait_for_cloud_init" {
  depends_on = [
    module.control_planes,
    module.workers,
  ]
  count = var.n_control_planes + var.n_workers
  provisioner "local-exec" {
    command = <<-EOF
      TARGET="${var.ip_prefix}.${var.start_ip + count.index}"
      echo "Waiting on SSH connection to $TARGET"
      while ! ${var.ssh_cmd} ${var.guest_username}@$TARGET; do sleep 10; done
      echo "Waiting on cloudinit"
      ${var.ssh_cmd} ${var.guest_username}@$TARGET 'cloud-init status --wait > /dev/null; rc=$?; [ $rc -eq 2 ] && rc=0; exit $rc'
    EOF
  }
}

resource "null_resource" "connect_control_planes" {
  depends_on = [null_resource.wait_for_cloud_init]
  count      = var.n_control_planes - 1
  provisioner "local-exec" {
    command = <<-EOF
      TARGET="${var.ip_prefix}.${var.start_ip + count.index + 1}"
      echo "Connecting $TARGET to cluster"
      JOIN_CMD=$(${local.first_node_ssh_cmd} "sudo kubeadm token create --print-join-command 2>/dev/null")
      ${var.ssh_cmd} ${var.guest_username}@$TARGET "sudo $JOIN_CMD --control-plane"
    EOF
  }
}

resource "null_resource" "connect_workers" {
  depends_on = [null_resource.wait_for_cloud_init]
  count      = var.n_workers
  provisioner "local-exec" {
    command = <<-EOF
      TARGET="${var.ip_prefix}.${var.start_ip + var.n_control_planes + count.index}"
      echo "Connecting $TARGET to cluster"
      JOIN_CMD=$(${local.first_node_ssh_cmd} "sudo kubeadm token create --print-join-command 2>/dev/null")
      ${var.ssh_cmd} ${var.guest_username}@$TARGET "sudo $JOIN_CMD"
    EOF
  }
}
