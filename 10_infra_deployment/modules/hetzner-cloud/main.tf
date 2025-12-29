terraform {
  required_providers {
    hcloud = {
      source  = "hetznercloud/hcloud"
      version = "~> 1.45"
    }
  }
}

# Hetzner Cloud Firewall
resource "hcloud_firewall" "server_fw" {
  name = var.firewall_name

  dynamic "rule" {
    for_each = var.firewall_rules
    content {
      direction  = rule.value.direction
      protocol   = rule.value.protocol
      port       = rule.value.port
      source_ips = rule.value.source_ips
    }
  }
}

# SSH Key
resource "hcloud_ssh_key" "server_ssh_key" {
  name       = var.ssh_key_name
  public_key = var.ssh_public_key
}

# Hetzner Cloud Server
resource "hcloud_server" "server" {
  name        = var.server_name
  image       = var.server_image
  server_type = var.server_type
  location    = var.location
  ssh_keys    = [hcloud_ssh_key.server_ssh_key.name]
  public_net {
    ipv4_enabled = var.enable_ipv4
    ipv6_enabled = var.enable_ipv6
  }
  firewall_ids = [hcloud_firewall.server_fw.id]

  # User Data
  user_data = var.user_data != null ? var.user_data : null

  # Labels to match Proxmox VMs
  labels = {
    environment = "production"
    network     = "tailscale"
    role        = "cloud"
    manager     = "true"
  }
}

# Snapshot of the Hetzner server
resource "hcloud_snapshot" "fresh_install_snapshot" {
  server_id = hcloud_server.server.id
}
