# Proxmox VM Module

This Terraform module creates and manages Proxmox virtual machines with flexible configuration options.

## Features

- Clone from existing VM templates
- Configurable hardware specifications (CPU, memory, disks)
- Network configuration with VLAN support
- Cloud-init integration for OS configuration
- Support for PCI and USB device passthrough
- Multiple disk configurations
- Comprehensive lifecycle management

## Usage

```hcl
module "worker_vm" {
  source = "./modules/proxmox-vm"

  # Basic Configuration
  name        = "coolify-worker0"
  description = "Managed by Terraform"
  tags        = ["community-script", "ubuntu"]
  node_name   = "pve-2"
  vm_id       = 3010

  # Clone Configuration
  template_vm_id = 9007
  full_clone     = true

  # Hardware
  memory_dedicated = 4096
  cpu_cores        = 2
  cpu_sockets      = 1

  # Disk Configuration
  disk_datastore_id = "vm-storage"
  disk_interface    = "scsi0"
  disk_size         = 30

  # Network Configuration
  network_bridge   = "vmbr0"
  network_model    = "virtio"
  network_vlan_id  = 30
  network_firewall = false

  # Initialization
  initialization_datastore_id = "vm-storage"
  dns_servers                 = ["9.9.9.9", "149.112.112.112"] # Quad9 DNS
  ipv4_address                = "10.0.30.10/24"
  ipv4_gateway                = "10.0.30.1"

  # Agent
  agent_enabled = false
  agent_timeout = "5m"
}
```

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_proxmox"></a> [proxmox](#requirement\_proxmox) | 0.89.1 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_proxmox"></a> [proxmox](#provider\_proxmox) | 0.89.1 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [proxmox_virtual_environment_file.user_data](https://registry.terraform.io/providers/bpg/proxmox/0.89.1/docs/resources/virtual_environment_file) | resource |
| [proxmox_virtual_environment_vm.vm](https://registry.terraform.io/providers/bpg/proxmox/0.89.1/docs/resources/virtual_environment_vm) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_additional_disks"></a> [additional\_disks](#input\_additional\_disks) | List of additional disks to create | <pre>list(object({<br/>    datastore_id = string<br/>    interface    = string<br/>    size         = number<br/>    file_format  = string<br/>    iothread     = bool<br/>    cache        = string<br/>    backup       = bool<br/>  }))</pre> | `[]` | no |
| <a name="input_agent_enabled"></a> [agent\_enabled](#input\_agent\_enabled) | Whether to enable the QEMU guest agent | `bool` | `false` | no |
| <a name="input_agent_timeout"></a> [agent\_timeout](#input\_agent\_timeout) | Timeout for the QEMU guest agent | `string` | `"5m"` | no |
| <a name="input_agent_trim"></a> [agent\_trim](#input\_agent\_trim) | Whether to enable TRIM support for the agent | `bool` | `true` | no |
| <a name="input_agent_type"></a> [agent\_type](#input\_agent\_type) | Type of the QEMU guest agent | `string` | `"virtio"` | no |
| <a name="input_cpu_cores"></a> [cpu\_cores](#input\_cpu\_cores) | Number of CPU cores | `number` | `1` | no |
| <a name="input_cpu_sockets"></a> [cpu\_sockets](#input\_cpu\_sockets) | Number of CPU sockets | `number` | `1` | no |
| <a name="input_cpu_type"></a> [cpu\_type](#input\_cpu\_type) | CPU type/model | `string` | `"host"` | no |
| <a name="input_description"></a> [description](#input\_description) | Description of the VM | `string` | `"Managed by Terraform"` | no |
| <a name="input_disk_cache"></a> [disk\_cache](#input\_disk\_cache) | Disk cache mode | `string` | `"none"` | no |
| <a name="input_disk_datastore_id"></a> [disk\_datastore\_id](#input\_disk\_datastore\_id) | The datastore where the disk will be stored | `string` | n/a | yes |
| <a name="input_disk_file_format"></a> [disk\_file\_format](#input\_disk\_file\_format) | Disk file format (raw, qcow2, etc.) | `string` | `"raw"` | no |
| <a name="input_disk_interface"></a> [disk\_interface](#input\_disk\_interface) | The disk interface type | `string` | `"scsi0"` | no |
| <a name="input_disk_iothread"></a> [disk\_iothread](#input\_disk\_iothread) | Whether to enable IO threads for the disk | `bool` | `false` | no |
| <a name="input_disk_size"></a> [disk\_size](#input\_disk\_size) | Size of the disk in GB | `number` | `20` | no |
| <a name="input_dns_servers"></a> [dns\_servers](#input\_dns\_servers) | List of DNS servers | `list(string)` | <pre>[<br/>  "9.9.9.9",<br/>  "149.112.112.112"<br/>]</pre> | no |
| <a name="input_efi_disk_enabled"></a> [efi\_disk\_enabled](#input\_efi\_disk\_enabled) | Whether to enable EFI disk | `bool` | `true` | no |
| <a name="input_full_clone"></a> [full\_clone](#input\_full\_clone) | Whether to perform a full clone (creates independent copy) | `bool` | `true` | no |
| <a name="input_initialization_datastore_id"></a> [initialization\_datastore\_id](#input\_initialization\_datastore\_id) | The datastore for cloud-init configuration | `string` | n/a | yes |
| <a name="input_initialization_user_data_file_id"></a> [initialization\_user\_data\_file\_id](#input\_initialization\_user\_data\_file\_id) | The Proxmox file ID for the user data snippet | `string` | `null` | no |
| <a name="input_ipv4_address"></a> [ipv4\_address](#input\_ipv4\_address) | IPv4 address in CIDR notation (e.g., 10.0.30.10/24) | `string` | `null` | no |
| <a name="input_ipv4_gateway"></a> [ipv4\_gateway](#input\_ipv4\_gateway) | IPv4 gateway address | `string` | `null` | no |
| <a name="input_ipv6_address"></a> [ipv6\_address](#input\_ipv6\_address) | IPv6 address in CIDR notation | `string` | `null` | no |
| <a name="input_ipv6_gateway"></a> [ipv6\_gateway](#input\_ipv6\_gateway) | IPv6 gateway address | `string` | `null` | no |
| <a name="input_memory_dedicated"></a> [memory\_dedicated](#input\_memory\_dedicated) | Amount of RAM to allocate to the VM in MB | `number` | `1024` | no |
| <a name="input_name"></a> [name](#input\_name) | The name of the VM | `string` | n/a | yes |
| <a name="input_network_bridge"></a> [network\_bridge](#input\_network\_bridge) | The bridge to connect the network device to | `string` | n/a | yes |
| <a name="input_network_firewall"></a> [network\_firewall](#input\_network\_firewall) | Whether to enable the firewall for this network device | `bool` | `false` | no |
| <a name="input_network_model"></a> [network\_model](#input\_network\_model) | Network device model | `string` | `"virtio"` | no |
| <a name="input_network_vlan_id"></a> [network\_vlan\_id](#input\_network\_vlan\_id) | VLAN ID for the network device | `number` | `null` | no |
| <a name="input_node_name"></a> [node\_name](#input\_node\_name) | The Proxmox node where the VM will be created | `string` | n/a | yes |
| <a name="input_on_boot"></a> [on\_boot](#input\_on\_boot) | Whether the VM should start on boot | `bool` | `true` | no |
| <a name="input_password"></a> [password](#input\_password) | Password for cloud-init (not recommended for production) | `string` | `null` | no |
| <a name="input_pci_devices"></a> [pci\_devices](#input\_pci\_devices) | List of PCI devices to passthrough | <pre>list(object({<br/>    device  = string<br/>    mapping = string<br/>    pcie    = bool<br/>    mdev    = string<br/>    rombar  = bool<br/>  }))</pre> | `[]` | no |
| <a name="input_pool_id"></a> [pool\_id](#input\_pool\_id) | Proxmox pool ID to assign the VM to | `string` | `null` | no |
| <a name="input_reboot_after_update"></a> [reboot\_after\_update](#input\_reboot\_after\_update) | Whether to reboot after updates | `bool` | `false` | no |
| <a name="input_ssh_keys"></a> [ssh\_keys](#input\_ssh\_keys) | List of SSH public keys for cloud-init | `list(string)` | `[]` | no |
| <a name="input_ssh_public_key_ed25519"></a> [ssh\_public\_key\_ed25519](#input\_ssh\_public\_key\_ed25519) | Ed25519 SSH public key content | `string` | `""` | no |
| <a name="input_ssh_public_key_rsa"></a> [ssh\_public\_key\_rsa](#input\_ssh\_public\_key\_rsa) | RSA SSH public key content | `string` | `""` | no |
| <a name="input_started"></a> [started](#input\_started) | Whether the VM should be started after creation | `bool` | `true` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | List of tags to assign to the VM | `list(string)` | `[]` | no |
| <a name="input_template_vm_id"></a> [template\_vm\_id](#input\_template\_vm\_id) | The VM ID of the template to clone from | `number` | n/a | yes |
| <a name="input_tpm_state_enabled"></a> [tpm\_state\_enabled](#input\_tpm\_state\_enabled) | Whether to enable TPM state | `bool` | `true` | no |
| <a name="input_usb_devices"></a> [usb\_devices](#input\_usb\_devices) | List of USB devices to passthrough | <pre>list(object({<br/>    mapping = string<br/>    usb3    = bool<br/>  }))</pre> | `[]` | no |
| <a name="input_user_data"></a> [user\_data](#input\_user\_data) | Optional user data content for cloud-init (simple shell commands).<br/><br/>Example usage:<br/>user\_data = <<EOF<br/>#cloud-config<br/>runcmd:<br/>  - echo "Simple initialization script"<br/>  - apt-get update<br/>  - echo "Initialization complete"<br/>EOF | `string` | `null` | no |
| <a name="input_username"></a> [username](#input\_username) | Username for cloud-init | `string` | `null` | no |
| <a name="input_vm_id"></a> [vm\_id](#input\_vm\_id) | The VM ID (must be unique across all VMs) | `number` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_vm_id"></a> [vm\_id](#output\_vm\_id) | The ID of the created VM |
| <a name="output_vm_ipv4_address"></a> [vm\_ipv4\_address](#output\_vm\_ipv4\_address) | The IPv4 address of the VM |
| <a name="output_vm_name"></a> [vm\_name](#output\_vm\_name) | The name of the created VM |
| <a name="output_vm_node_name"></a> [vm\_node\_name](#output\_vm\_node\_name) | The Proxmox node where the VM is running |
| <a name="output_vm_tags"></a> [vm\_tags](#output\_vm\_tags) | The tags assigned to the VM |
<!-- END_TF_DOCS -->

## Examples

### Basic Worker Node
```hcl
module "worker0" {
  source = "./modules/proxmox-vm"

  name      = "coolify-worker0"
  node_name = "pve-2"
  vm_id     = 3010

  template_vm_id = 9007
  memory_dedicated = 4096
  disk_size = 30
  disk_datastore_id = "vm-storage"

  network_bridge  = "vmbr0"
  network_vlan_id = 30
  ipv4_address    = "10.0.30.10/24"
  ipv4_gateway    = "10.0.30.1"
}
