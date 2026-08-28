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

variable "user_data_file_id" {
  description = "File ID for cloud-init user config"
  type        = string
  nullable    = false
}

variable "n_control_planes" {
  description = "Number of kubernets control planes to create"
  type        = number
  nullable    = false
  default     = 1
}

variable "n_workers" {
  description = "Number of kubernetes workers to create"
  type        = number
  nullable    = false
  default     = 2
}

variable "start_ip" {
  description = "Number to start last octet in kubernetes ip from"
  type        = number
  nullable    = false
  default     = 150
}

variable "guest_network_interface" {
  description = "Network interface name inside the guest"
  type        = string
  nullable    = false
  default     = "ens18"
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
