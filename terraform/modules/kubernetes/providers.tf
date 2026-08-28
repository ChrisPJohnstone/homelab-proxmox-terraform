terraform {
  required_version = ">= 1.15.6, < 2.0.0"
  required_providers {
    proxmox = {
      source  = "bpg/proxmox"
      version = "~> 0.111"
    }
    null = {
      source  = "hashicorp/null"
      version = ">= 3.3.1, < 4.0.0"
    }
  }
}
