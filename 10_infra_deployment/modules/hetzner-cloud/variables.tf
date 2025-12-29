variable "firewall_name" {
  description = "Name of the firewall"
  type        = string
}

variable "firewall_rules" {
  description = "List of firewall rules"
  type = list(object({
    direction  = string
    protocol   = string
    port       = string
    source_ips = list(string)
  }))
}

variable "ssh_key_name" {
  description = "Name of the SSH key"
  type        = string
}

variable "ssh_public_key" {
  description = "Public SSH key content"
  type        = string
}

variable "server_name" {
  description = "Name of the server"
  type        = string
}

variable "server_image" {
  description = "Server image (e.g., ubuntu-22.04)"
  type        = string
}

variable "server_type" {
  description = "Server type (e.g., cx23)"
  type        = string
}

variable "location" {
  description = "Server location (e.g., hel1)"
  type        = string
}

variable "enable_ipv4" {
  description = "Enable IPv4"
  type        = bool
}

variable "enable_ipv6" {
  description = "Enable IPv6"
  type        = bool
}

variable "user_data" {
  description = <<-EOT
    User data script for server initialization.

    Example usage:
    user_data = <<EOF
    #cloud-config
    runcmd:
      - echo "Simple Hetzner initialization script"
      - apt-get update
      - echo "Hetzner initialization complete"
    EOF
    EOT
  type        = string
  default     = null
}