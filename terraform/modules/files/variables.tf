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

variable "content_type" {
  description = "Content type of file"
  type        = string
  nullable    = false
}

variable "file_source" {
  description = "Where to get file from"
  type        = string
  nullable    = false
}

variable "file_name" {
  description = "Name to save file as"
  type        = string
  nullable    = false
}
