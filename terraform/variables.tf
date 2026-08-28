variable "host" {
  description = "Host for proxmox endpoint"
  type        = string
  nullable    = false
}

variable "port" {
  description = "Port for proxmox endpoint"
  type        = number
  nullable    = false
  default     = 8006
}

variable "insecure" {
  description = "Whether to skip TLS verification"
  type        = bool
  nullable    = false
  default     = true
}

variable "token_username" {
  description = "Username for proxmox API token"
  type        = string
  nullable    = false
}

variable "token_name" {
  description = "Name of the proxmox API token"
  type        = string
  nullable    = false
}

variable "token_key" {
  description = "Secret key for the proxmox API token"
  type        = string
  nullable    = false
}

variable "ssh_username" {
  description = "Username for ssh-agent"
  type        = string
  nullable    = false
}

variable "node_name" {
  description = "Proxmox node name"
  type        = string
  nullable    = false
  default     = "proxmox"
}

variable "n_kubernetes_control_planes" {
  description = "Number of kubernets control planes to create"
  type        = number
  nullable    = false
  default     = 1
}

variable "n_kubernetes_workers" {
  description = "Number of kubernetes workers to create"
  type        = number
  nullable    = false
  default     = 2
}

variable "kubernetes_start_ip" {
  description = "Number to start last octet in kubernetes ip from"
  type        = number
  nullable    = false
  default     = 150
}
