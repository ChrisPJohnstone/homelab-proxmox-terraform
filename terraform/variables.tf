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

variable "api_token" {
  description = "API Token for auth"
  type        = string
  nullable    = false
}

variable "node_name" {
  description = "Proxmox node name"
  type        = string
  nullable    = false
  default     = "proxmox"
}
