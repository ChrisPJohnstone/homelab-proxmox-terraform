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

variable "kubernetes_control_planes" {
  # I accept that this should be `n` nodes but this sparks joy
  description = "List of kubernetes control planes to create"
  type        = set(string)
  nullable    = false
  default     = ["gaffer"]
}

variable "kubernetes_workers" {
  # I accept that this should be `n` nodes but this sparks joy
  description = "List of kubernetes workers to create"
  type        = set(string)
  nullable    = false
  default     = ["hoddit", "doddit"]
}
