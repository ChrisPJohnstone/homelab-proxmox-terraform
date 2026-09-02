locals {
  guest_cidr = "${cidrhost("${var.guest_ip}/${var.guest_subnet}", 0)}/${var.guest_subnet}"
}

