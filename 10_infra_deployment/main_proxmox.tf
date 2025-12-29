# Proxmox VMs using the proxmox-vm module

locals {
  # Shared DNS configuration
  dns_servers = [
    "9.9.9.9",
    "149.112.112.112"
  ]

  # Shared VM configuration
  vm_common = {
    description    = "Terraform Managed Docker Controller VM"
    tags           = ["community-script", "debian13", "docker", "controller", "terraform"]
    node_name      = "pve-2"
    template_vm_id = 9008
    template_node_name = "pve-2"
    full_clone     = true

    # Agent Configuration
    agent_enabled = false
    agent_timeout = "5m"

    # Hardware Configuration
    memory_dedicated = 8192
    cpu_cores        = 4
    cpu_sockets      = 2

    # Disk Configuration
    disk_datastore_id = "vm-storage"
    disk_interface    = "virtio0"
    disk_size         = 32
    disk_iothread     = true

    # Additional Disks (GlusterFS)
    additional_disks = [
      {
        datastore_id = "vm-storage"
        interface    = "scsi0"
        size         = 30
        file_format  = "raw"
        iothread     = true
        cache        = "none"
        backup       = true
      }
    ]

    # Network Configuration
    network_bridge   = "vmbr0"
    network_model    = "virtio"
    network_vlan_id  = 30
    network_firewall = false

    # Initialization Configuration
    initialization_datastore_id = "vm-storage"
    dns_servers                 = local.dns_servers

    # VM Lifecycle Settings
    on_boot             = true
    reboot_after_update = false
    started             = true

    # EFI and TPM
    efi_disk_enabled  = true
    tpm_state_enabled = true
  }

  # VM-specific configurations
  dkr_srv_1 = {
    name         = "dkr-srv-1"
    vm_id        = 3011
    node_name    = "pve-0"
    ipv4_address = "10.0.30.11/24"
    ipv4_gateway = "10.0.30.1"
  }

  dkr_srv_2 = {
    name         = "dkr-srv-2"
    vm_id        = 3012
    node_name    = "pve-1"
    ipv4_address = "10.0.30.12/24"
    ipv4_gateway = "10.0.30.1"
  }

  dkr_srv_3 = {
    name         = "dkr-srv-3"
    vm_id        = 3013
    node_name    = "pve-2"
    ipv4_address = "10.0.30.13/24"
    ipv4_gateway = "10.0.30.1"
  }
}

module "dkr_srv_1" {
  source = "./modules/proxmox-vm"

  # Basic Configuration
  name        = local.dkr_srv_1.name
  description = local.vm_common.description
  tags        = local.vm_common.tags
  node_name   = local.dkr_srv_1.node_name
  vm_id       = local.dkr_srv_1.vm_id
  # Clone Configuration
  template_vm_id     = local.vm_common.template_vm_id
  template_node_name = local.vm_common.template_node_name
  full_clone         = local.vm_common.full_clone

  # Agent Configuration
  agent_enabled = local.vm_common.agent_enabled
  agent_timeout = local.vm_common.agent_timeout

  # Hardware Configuration
  memory_dedicated = local.vm_common.memory_dedicated
  cpu_cores        = local.vm_common.cpu_cores
  cpu_sockets      = local.vm_common.cpu_sockets

  # Disk Configuration
  disk_datastore_id = local.vm_common.disk_datastore_id
  disk_interface    = local.vm_common.disk_interface
  disk_size         = local.vm_common.disk_size
  disk_iothread     = local.vm_common.disk_iothread
  additional_disks  = local.vm_common.additional_disks

  # Network Configuration
  network_bridge   = local.vm_common.network_bridge
  network_model    = local.vm_common.network_model
  network_vlan_id  = local.vm_common.network_vlan_id
  network_firewall = local.vm_common.network_firewall

  # SSH Keys - include both keys
  # SSH Keys - include both keys
  ssh_keys = var.ssh_public_keys

  # User Configuration
  username = var.ci_user

  # Initialization Configuration
  initialization_datastore_id = local.vm_common.initialization_datastore_id
  dns_servers                 = local.vm_common.dns_servers
  ipv4_address                = local.dkr_srv_1.ipv4_address
  ipv4_gateway                = local.dkr_srv_1.ipv4_gateway

  # VM Lifecycle Settings
  on_boot             = local.vm_common.on_boot
  reboot_after_update = local.vm_common.reboot_after_update
  started             = local.vm_common.started

  # EFI and TPM
  efi_disk_enabled  = local.vm_common.efi_disk_enabled
  tpm_state_enabled = local.vm_common.tpm_state_enabled
}

module "dkr_srv_2" {
  source = "./modules/proxmox-vm"

  # Basic Configuration
  name        = local.dkr_srv_2.name
  description = local.vm_common.description
  tags        = local.vm_common.tags
  node_name   = local.dkr_srv_2.node_name
  vm_id       = local.dkr_srv_2.vm_id
  # Clone Configuration
  template_vm_id     = local.vm_common.template_vm_id
  template_node_name = local.vm_common.template_node_name
  full_clone         = local.vm_common.full_clone

  # Agent Configuration
  agent_enabled = local.vm_common.agent_enabled
  agent_timeout = local.vm_common.agent_timeout

  # Hardware Configuration
  memory_dedicated = local.vm_common.memory_dedicated
  cpu_cores        = local.vm_common.cpu_cores
  cpu_sockets      = local.vm_common.cpu_sockets

  # Disk Configuration
  disk_datastore_id = local.vm_common.disk_datastore_id
  disk_interface    = local.vm_common.disk_interface
  disk_size         = local.vm_common.disk_size
  disk_iothread     = local.vm_common.disk_iothread
  additional_disks  = local.vm_common.additional_disks

  # Network Configuration
  network_bridge   = local.vm_common.network_bridge
  network_model    = local.vm_common.network_model
  network_vlan_id  = local.vm_common.network_vlan_id
  network_firewall = local.vm_common.network_firewall

  # SSH Keys
  # SSH Keys - include both keys
  ssh_keys = var.ssh_public_keys

  # User Configuration
  username = var.ci_user

  # Initialization Configuration
  initialization_datastore_id = local.vm_common.initialization_datastore_id
  dns_servers                 = local.vm_common.dns_servers
  ipv4_address                = local.dkr_srv_2.ipv4_address
  ipv4_gateway                = local.dkr_srv_2.ipv4_gateway

  # VM Lifecycle Settings
  on_boot             = local.vm_common.on_boot
  reboot_after_update = local.vm_common.reboot_after_update
  started             = local.vm_common.started

  # EFI and TPM
  efi_disk_enabled  = local.vm_common.efi_disk_enabled
  tpm_state_enabled = local.vm_common.tpm_state_enabled
}

module "dkr_srv_3" {
  source = "./modules/proxmox-vm"

  # Basic Configuration
  name        = local.dkr_srv_3.name
  description = local.vm_common.description
  tags        = local.vm_common.tags
  node_name   = local.dkr_srv_3.node_name
  vm_id       = local.dkr_srv_3.vm_id

  # Clone Configuration
  template_vm_id     = local.vm_common.template_vm_id
  template_node_name = local.vm_common.template_node_name
  full_clone         = local.vm_common.full_clone

  # Agent Configuration
  agent_enabled = local.vm_common.agent_enabled
  agent_timeout = local.vm_common.agent_timeout

  # Hardware Configuration
  memory_dedicated = local.vm_common.memory_dedicated
  cpu_cores        = local.vm_common.cpu_cores
  cpu_sockets      = local.vm_common.cpu_sockets

  # Disk Configuration
  disk_datastore_id = local.vm_common.disk_datastore_id
  disk_interface    = local.vm_common.disk_interface
  disk_size         = local.vm_common.disk_size
  disk_iothread     = local.vm_common.disk_iothread
  additional_disks  = local.vm_common.additional_disks

  # Network Configuration
  network_bridge   = local.vm_common.network_bridge
  network_model    = local.vm_common.network_model
  network_vlan_id  = local.vm_common.network_vlan_id
  network_firewall = local.vm_common.network_firewall

  # SSH Keys
  # SSH Keys - include both keys
  ssh_keys = var.ssh_public_keys

  # User Configuration
  username = var.ci_user

  # Initialization Configuration
  initialization_datastore_id = local.vm_common.initialization_datastore_id
  dns_servers                 = local.vm_common.dns_servers
  ipv4_address                = local.dkr_srv_3.ipv4_address
  ipv4_gateway                = local.dkr_srv_3.ipv4_gateway

  # VM Lifecycle Settings
  on_boot             = local.vm_common.on_boot
  reboot_after_update = local.vm_common.reboot_after_update
  started             = local.vm_common.started

  # EFI and TPM
  efi_disk_enabled  = local.vm_common.efi_disk_enabled
  tpm_state_enabled = local.vm_common.tpm_state_enabled
}