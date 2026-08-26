variable "node_name" {
  description = "Proxmox node name"
  type        = string
  nullable    = false
}

variable "vm_name" {
  description = "Name to create VM under"
  type        = string
  nullable    = false
}

variable "cpu_type" {
  description = "Type of CPU to give VM"
  type        = string
  nullable    = false
  default     = "x86-64-v2-AES"
}

variable "cpu_cores" {
  description = "Name to create VM under"
  type        = number
  nullable    = false
  default     = 2
}

variable "memory_dedicated" {
  description = "Dedicated memory allocation for VM in MB"
  type        = number
  nullable    = false
  default     = 4 * 1024
}

variable "memory_floating" {
  description = "Floating memory allocation for VM in MB"
  type        = number
  nullable    = false
  default     = 0
}

variable "memory_shared" {
  description = "Shared memory allocation for VM in MB"
  type        = number
  nullable    = false
  default     = 0
}

variable "datastore_id" {
  description = "Datastore to create disk on"
  type        = string
  nullable    = false
  default     = "local-zfs"
}

variable "image_id" {
  description = "File ID for image to import into VM"
  type        = string
  nullable    = false
}
