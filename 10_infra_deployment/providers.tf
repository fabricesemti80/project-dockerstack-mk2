terraform {
  required_providers {
    hcloud = {
      source  = "hetznercloud/hcloud"
      version = "~> 1.45"
    }
    proxmox = {
      source  = "bpg/proxmox"
      version = "0.90.0"
    }
    cloudflare = {
      source  = "cloudflare/cloudflare"
      version = "~> 5.0"
    }
    doppler = {
      source  = "dopplerhq/doppler"
      version = "~> 1.0"
    }
    http = {
      source  = "hashicorp/http"
      version = "~> 3.0"
    }
  }
}

provider "doppler" {
  # Value will be passed via DOPPLER_TOKEN env var in Taskfile
}

provider "hcloud" {
  token = var.HCLOUD_TOKEN
}

provider "cloudflare" {
  api_token = var.CLOUDFLARE_API_TOKEN
}

provider "proxmox" {
  endpoint  = "https://10.0.40.10:8006/"
  api_token = var.PROXMOX_VE_API_TOKEN
  insecure  = true
  ssh {
    username    = "root"
    agent       = false
    private_key = file(pathexpand(var.proxmox_ssh_private_key_file))
    node {
      name    = "pve-2"
      address = "10.0.40.10"
    }
  }
}
