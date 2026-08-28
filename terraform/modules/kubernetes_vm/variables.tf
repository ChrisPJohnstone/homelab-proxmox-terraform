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

variable "name" {
  description = "Name to give VM"
  type        = string
  nullable    = false
}

variable "debian_image_id" {
  description = "File ID for debian image"
  type        = string
  nullable    = false
}

variable "guest_network_interface" {
  description = "Network interface name inside the guest"
  type        = string
  nullable    = false
  default     = "net0"
}

variable "guest_ip" {
  description = "Static IP address for the guest (e.g. 192.168.122.10)"
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
