output "server_name" {
  description = "The name of the server."
  value       = hcloud_server.server.name
}

output "server_ipv4_address" {
  description = "The public IPv4 address of the server."
  value       = hcloud_server.server.ipv4_address
}

output "server_ipv6_address" {
  description = "The public IPv6 address of the server."
  value       = hcloud_server.server.ipv6_address
}

# Snapshot outputs
output "snapshot_id" {
  description = "The ID of the snapshot created from the server"
  value       = hcloud_snapshot.fresh_install_snapshot.id
}
