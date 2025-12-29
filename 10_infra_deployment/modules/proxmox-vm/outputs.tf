# Proxmox VM Module Outputs

output "vm_id" {
  description = "The ID of the created VM"
  value       = proxmox_virtual_environment_vm.vm.vm_id
}

output "vm_name" {
  description = "The name of the created VM"
  value       = proxmox_virtual_environment_vm.vm.name
}

output "vm_ipv4_address" {
  description = "The IPv4 address of the VM"
  value       = var.agent_enabled && length(proxmox_virtual_environment_vm.vm.ipv4_addresses) > 0 ? proxmox_virtual_environment_vm.vm.ipv4_addresses[0][0] : var.ipv4_address
}

output "vm_node_name" {
  description = "The Proxmox node where the VM is running"
  value       = proxmox_virtual_environment_vm.vm.node_name
}

# output "vm_status" {
#   description = "The status of the VM"
#   value       = proxmox_virtual_environment_vm.vm.status
# }

output "vm_tags" {
  description = "The tags assigned to the VM"
  value       = proxmox_virtual_environment_vm.vm.tags
}
