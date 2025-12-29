terraform {
  required_providers {
    proxmox = {
      source  = "bpg/proxmox"
      version = "0.90.0"
    }
  }
}

provider "proxmox" {
  endpoint = var.proxmox_endpoint
  insecure = true

  # Authentication via PROXMOX_VE_API_TOKEN environment variable is recommended
  
  ssh {
    username = var.proxmox_ssh_username
    agent    = true
  }
}
