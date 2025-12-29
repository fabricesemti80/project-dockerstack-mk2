# --- Global / Common ---

variable "proxmox_ssh_private_key_file" {
  description = "Path to the SSH private key for Proxmox"
  type        = string
  default     = "~/.ssh/fs_home_rsa"
}

variable "ssh_public_keys" {
  description = "List of SSH public keys to inject into VMs"
  type        = list(string)
}

variable "ci_user" {
  description = "The username to create on the VMs"
  type        = string
}

# --- Hetzner Cloud ---

variable "HCLOUD_TOKEN" {
  description = "Hetzner Cloud API Token"
  type        = string
  sensitive   = true
}

# --- Proxmox ---

variable "PROXMOX_VE_API_TOKEN" {
  description = "Proxmox VE API Token (terraform@pve!provider=xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx)"
  type        = string
  sensitive   = true
}

# --- Cloudflare ---

variable "CLOUDFLARE_API_TOKEN" {
  description = "Cloudflare API Token"
  type        = string
  sensitive   = true
}

variable "CLOUDFLARE_ACCOUNT_ID" {
  description = "Cloudflare Account ID"
  type        = string
  sensitive   = true
}

variable "CLOUDFLARE_ZONE_ID" {
  description = "Cloudflare Zone ID for krapulax.dev"
  type        = string
  sensitive   = true
}

variable "ACCESS_EMAIL" {
  description = "The email address allowed to access the lab services"
  type        = string
  default     = "emilfabrice@gmail.com"
}
