terraform {
  required_version = ">= 1.15.6, < 2.0.0"
  required_providers {
    proxmox = {
      source  = "bpg/proxmox"
      version = "~> 0.111"
    }
  }
}

provider "proxmox" {
  endpoint  = "https://${var.host}:${var.port}"
  insecure  = var.insecure
  api_token = var.api_token
}
