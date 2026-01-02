variable "name" {
  description = "The name of the VM"
  type        = string
}

variable "description" {
  description = "The description of the VM"
  type        = string
  default     = ""
}

variable "tags" {
  description = "Tags to apply to the VM"
  type        = list(string)
  default     = []
}

variable "node_name" {
  description = "The name of the node to deploy the VM on"
  type        = string
}

variable "vm_id" {
  description = "The ID of the VM"
  type        = number
  default     = null
}

variable "template_vm_id" {
  description = "The ID of the template VM to clone"
  type        = number
}

variable "template_node_name" {
  description = "The name of the node where the template resides"
  type        = string
  default     = null
}

variable "full_clone" {
  description = "Whether to perform a full clone"
  type        = bool
  default     = true
}

variable "agent_enabled" {
  description = "Whether to enable the QEMU agent"
  type        = bool
  default     = true
}

variable "agent_timeout" {
  description = "The timeout for the QEMU agent"
  type        = string
  default     = "15m"
}

variable "agent_trim" {
  description = "Whether to enable TRIM on the disk"
  type        = bool
  default     = true
}

variable "agent_type" {
  description = "The type of the QEMU agent"
  type        = string
  default     = "virtio"
}

variable "memory_dedicated" {
  description = "The amount of dedicated memory in MB"
  type        = number
  default     = 2048
}

variable "cpu_cores" {
  description = "The number of CPU cores"
  type        = number
  default     = 2
}

variable "cpu_sockets" {
  description = "The number of CPU sockets"
  type        = number
  default     = 1
}

variable "cpu_type" {
  description = "The type of the CPU"
  type        = string
  default     = "host"
}

variable "disk_datastore_id" {
  description = "The datastore ID for the disk"
  type        = string
  default     = "local-lvm"
}

variable "disk_interface" {
  description = "The interface for the disk"
  type        = string
  default     = "scsi0"
}

variable "disk_size" {
  description = "The size of the disk in GB"
  type        = number
  default     = 20
}

variable "disk_file_format" {
  description = "The file format for the disk"
  type        = string
  default     = "raw"
}

variable "disk_iothread" {
  description = "Whether to enable iothread for the disk"
  type        = bool
  default     = true
}

variable "disk_cache" {
  description = "The cache mode for the disk"
  type        = string
  default     = "none"
}

variable "additional_disks" {
  description = "List of additional disks to attach"
  type = list(object({
    datastore_id = string
    interface    = string
    size         = number
    file_format  = string
    iothread     = bool
    cache        = string
    backup       = bool
  }))
  default = []
}

variable "efi_disk_enabled" {
  description = "Whether to enable the EFI disk"
  type        = bool
  default     = false
}

variable "tpm_state_enabled" {
  description = "Whether to enable the TPM state"
  type        = bool
  default     = false
}

variable "pci_devices" {
  description = "List of PCI devices to pass through"
  type = list(object({
    id      = optional(string)
    mapping = optional(string)
    pcie    = optional(bool, false)
    mdev    = optional(string)
    rombar  = optional(bool, true)
    xvga    = optional(bool, false)
  }))
  default = []
}

variable "usb_devices" {
  description = "List of USB devices to pass through"
  type = list(object({
    mapping = string
    usb3    = bool
  }))
  default = []
}

variable "network_bridge" {
  description = "The bridge for the network interface"
  type        = string
  default     = "vmbr0"
}

variable "network_model" {
  description = "The model for the network interface"
  type        = string
  default     = "virtio"
}

variable "network_vlan_id" {
  description = "The VLAN ID for the network interface"
  type        = number
  default     = null
}

variable "network_firewall" {
  description = "Whether to enable the firewall on the network interface"
  type        = bool
  default     = false
}

variable "additional_networks" {
  description = "List of additional network interfaces to attach"
  type = list(object({
    bridge   = string
    model    = string
    vlan_id  = number
    firewall = bool
  }))
  default = []
}

variable "initialization_datastore_id" {
  description = "The datastore ID for the cloud-init disk"
  type        = string
  default     = "local-lvm"
}

variable "initialization_user_data_file_id" {
  description = "The file ID for the cloud-init user data"
  type        = string
  default     = null
}

variable "dns_servers" {
  description = "List of DNS servers"
  type        = list(string)
  default     = []
}

variable "ipv4_address" {
  description = "The IPv4 address for the VM"
  type        = string
  default     = "dhcp"
}

variable "ipv4_gateway" {
  description = "The IPv4 gateway for the VM"
  type        = string
  default     = null
}

variable "additional_ipv4_addresses" {
  description = "List of additional IPv4 addresses for the VM (no gateway)"
  type        = list(string)
  default     = []
}

variable "ipv6_address" {
  description = "The IPv6 address for the VM"
  type        = string
  default     = null
}

variable "ipv6_gateway" {
  description = "The IPv6 gateway for the VM"
  type        = string
  default     = null
}

variable "username" {
  description = "The username for the cloud-init user"
  type        = string
  default     = null
}

variable "password" {
  description = "The password for the cloud-init user"
  type        = string
  default     = null
}

variable "ssh_keys" {
  description = "List of SSH keys for the cloud-init user"
  type        = list(string)
  default     = []
}

variable "ssh_public_key_rsa" {
  description = "RSA SSH public key"
  type        = string
  default     = ""
}

variable "ssh_public_key_ed25519" {
  description = "ED25519 SSH public key"
  type        = string
  default     = ""
}

variable "user_data" {
  description = "The cloud-init user data"
  type        = string
  default     = null
}

variable "on_boot" {
  description = "Whether to start the VM on boot"
  type        = bool
  default     = true
}

variable "reboot_after_update" {
  description = "Whether to reboot the VM after update"
  type        = bool
  default     = false
}

variable "started" {
  description = "Whether the VM should be started"
  type        = bool
  default     = true
}

variable "pool_id" {
  description = "The ID of the resource pool"
  type        = string
  default     = null
}