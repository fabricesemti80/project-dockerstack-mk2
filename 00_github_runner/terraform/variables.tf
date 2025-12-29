variable "proxmox_endpoint" {
  description = "The endpoint for the Proxmox API"
  type        = string
  default     = "https://10.0.40.10:8006/"
}

variable "proxmox_ssh_username" {
  description = "The username for SSH connection to Proxmox nodes"
  type        = string
  default     = "root"
}

variable "vm_name" {
  description = "The name of the VM"
  type        = string
  default     = "github-runner-01"
}

variable "node_name" {
  description = "The Proxmox node to deploy the VM on"
  type        = string
  default     = "pve-2"
}

variable "vm_id" {
  description = "The ID of the VM"
  type        = number
  default     = 4001
}

variable "template_vm_id" {
  description = "The ID of the template VM to clone"
  type        = number
  default     = 9008
}

variable "ssh_public_keys" {
  description = "List of SSH public keys to add to the VM"
  type        = list(string)
}

variable "ci_user" {
  description = "The username to create on the VM"
  type        = string
  default     = "fs"
}
