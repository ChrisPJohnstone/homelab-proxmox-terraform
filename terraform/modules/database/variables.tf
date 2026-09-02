variable "node_name" {
  description = "Proxmox node name"
  type        = string
  nullable    = false
}

variable "datastore_id" {
  description = "Datastore to save file to"
  type        = string
  nullable    = false
  default     = "local"
}

variable "debian_image_id" {
  description = "File ID for debian image"
  type        = string
  nullable    = false
}

variable "ssh_public_key_file" {
  description = "Path to the public SSH key to install on VMs for access"
  type        = string
  nullable    = false
}

variable "hostname" {
  description = "Host name to assign to VM"
  type        = string
  nullable    = false
  default     = "database"
}

variable "guest_username" {
  description = "Username to create on vm"
  type        = string
  nullable    = false
}

variable "guest_ip" {
  description = "IP to assign to guest"
  type        = string
  nullable    = false
}

variable "guest_subnet" {
  description = "Subnet for guest"
  type        = number
  nullable    = false
  default     = 24
}

variable "guest_gateway" {
  description = "Default gateway for the guest"
  type        = string
  nullable    = false
  default     = "192.168.0.1"
}

variable "guest_dns_servers" {
  description = "DNS servers for the guest"
  type        = list(string)
  nullable    = false
  default     = ["8.8.8.8", "1.1.1.1"]
}

variable "guest_network_interface" {
  description = "Network interface name inside the guest"
  type        = string
  nullable    = false
  default     = "ens18"
}

variable "admin_password" {
  description = "Password to set for admin user"
  type        = string
  nullable    = false
  sensitive   = true
}
