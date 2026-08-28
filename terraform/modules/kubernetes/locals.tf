locals {
  first_node_ip      = "${var.ip_prefix}.${var.start_ip}"
  first_node_ssh_cmd = "${var.ssh_cmd} ${var.guest_username}@${local.first_node_ip}"

}
