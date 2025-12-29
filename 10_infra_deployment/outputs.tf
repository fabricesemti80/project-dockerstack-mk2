# --- Cloudflare Tunnel ---

output "tunnel_name" {
  description = "The name of the created Cloudflare Tunnel"
  value       = cloudflare_zero_trust_tunnel_cloudflared.main.name
}

output "tunnel_id" {
  description = "The UUID of the created Cloudflare Tunnel"
  value       = cloudflare_zero_trust_tunnel_cloudflared.main.id
}

output "wildcard_dns" {
  description = "The Wildcard DNS record pointing to the tunnel"
  value       = "*.${data.cloudflare_zone.krapulax_dev.name} -> ${cloudflare_zero_trust_tunnel_cloudflared.main.id}.cfargotunnel.com"
}

# --- Hetzner Cloud ---

output "dkr_srv_0_name" {
  description = "The name of the dkr_srv_0 server"
  value       = module.dkr_srv_0.server_name
}

output "dkr_srv_0_ipv4" {
  description = "The public IPv4 address of the dkr_srv_0 server"
  value       = module.dkr_srv_0.server_ipv4_address
}

output "dkr_srv_0_ipv6" {
  description = "The public IPv6 address of the dkr_srv_0 server"
  value       = module.dkr_srv_0.server_ipv6_address
}

output "dkr_srv_0_snapshot_id" {
  description = "The ID of the snapshot created from dkr_srv_0"
  value       = module.dkr_srv_0.snapshot_id
}

# --- Proxmox ---

output "dkr_srv_1_vm_id" {
  description = "The ID of the dkr-srv-1 VM"
  value       = module.dkr_srv_1.vm_id
}

output "dkr_srv_1_vm_name" {
  description = "The name of the dkr-srv-1 VM"
  value       = module.dkr_srv_1.vm_name
}

output "dkr_srv_1_vm_node" {
  description = "The Proxmox node where dkr-srv-1 is running"
  value       = module.dkr_srv_1.vm_node_name
}

output "dkr_srv_2_vm_id" {
  description = "The ID of the dkr-srv-2 VM"
  value       = module.dkr_srv_2.vm_id
}

output "dkr_srv_2_vm_name" {
  description = "The name of the dkr-srv-2 VM"
  value       = module.dkr_srv_2.vm_name
}

output "dkr_srv_2_vm_node" {
  description = "The Proxmox node where dkr-srv-2 is running"
  value       = module.dkr_srv_2.vm_node_name
}

output "dkr_srv_3_vm_id" {
  description = "The ID of the dkr-srv-3 VM"
  value       = module.dkr_srv_3.vm_id
}

output "dkr_srv_3_vm_name" {
  description = "The name of the dkr-srv-3 VM"
  value       = module.dkr_srv_3.vm_name
}

output "dkr_srv_3_vm_node" {
  description = "The Proxmox node where dkr-srv-3 is running"
  value       = module.dkr_srv_3.vm_node_name
}
