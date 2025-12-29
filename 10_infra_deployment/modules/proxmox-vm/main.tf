# Proxmox VM Module

terraform {
  required_providers {
    proxmox = {
      source = "bpg/proxmox"
      version = "0.89.1"
    }
  }
}

locals {
  # Quad9 DNS servers for enhanced privacy and security
  quad9_dns_servers = [
    "9.9.9.9",
    "149.112.112.112"
  ]
}

# Create user data file only if user_data is provided
resource "proxmox_virtual_environment_file" "user_data" {
  count = var.user_data != null ? 1 : 0

  node_name    = var.node_name
  datastore_id = var.initialization_datastore_id
  content_type = "snippets"

  source_raw {
    data    = var.user_data
    file_name = "${var.name}-user-data.yaml"
  }
}

resource "proxmox_virtual_environment_vm" "vm" {
  name        = var.name
  description = var.description
  tags        = var.tags
  node_name   = var.node_name
  vm_id       = var.vm_id

  clone {
    vm_id     = var.template_vm_id
    full      = var.full_clone
    node_name = var.template_node_name
  }

  agent {
    enabled = var.agent_enabled
    timeout = var.agent_timeout
    trim    = var.agent_trim
    type    = var.agent_type
  }

  memory {
    dedicated = var.memory_dedicated
  }

  cpu {
    cores   = var.cpu_cores
    sockets = var.cpu_sockets
    type    = var.cpu_type
  }

  disk {
    datastore_id = var.disk_datastore_id
    interface    = var.disk_interface
    size         = var.disk_size
    file_format  = var.disk_file_format
    iothread     = var.disk_iothread
    cache        = var.disk_cache
  }

  dynamic "disk" {
    for_each = var.additional_disks
    content {
      datastore_id = disk.value.datastore_id
      interface    = disk.value.interface
      size         = disk.value.size
      file_format  = disk.value.file_format
      iothread     = disk.value.iothread
      cache        = disk.value.cache
      backup       = disk.value.backup
    }
  }

  dynamic "efi_disk" {
    for_each = var.efi_disk_enabled ? [1] : []
    content {
      datastore_id = var.disk_datastore_id
      file_format  = var.disk_file_format
    }
  }

  dynamic "tpm_state" {
    for_each = var.tpm_state_enabled ? [1] : []
    content {
      datastore_id = var.disk_datastore_id
      version      = "v2.0"
    }
  }

  dynamic "hostpci" {
    for_each = var.pci_devices
    content {
      device  = hostpci.value.device
      mapping = hostpci.value.mapping
      pcie    = hostpci.value.pcie
      mdev    = hostpci.value.mdev
      rombar  = hostpci.value.rombar
    }
  }

  dynamic "usb" {
    for_each = var.usb_devices
    content {
      mapping = usb.value.mapping
      usb3    = usb.value.usb3
    }
  }

  network_device {
    bridge   = var.network_bridge
    model    = var.network_model
    vlan_id  = var.network_vlan_id
    firewall = var.network_firewall
  }

  initialization {
    datastore_id = var.initialization_datastore_id
    dns {
      servers = var.dns_servers
    }
    user_data_file_id = var.user_data != null ? proxmox_virtual_environment_file.user_data[0].id : var.initialization_user_data_file_id

    dynamic "ip_config" {
      for_each = [1]  # Always create this block
      content {
        dynamic "ipv4" {
          for_each = var.ipv4_address != null ? [1] : []
          content {
            address = var.ipv4_address
            gateway = var.ipv4_gateway
          }
        }

        dynamic "ipv6" {
          for_each = var.ipv6_address != null ? [1] : []
          content {
            address = var.ipv6_address
            gateway = var.ipv6_gateway
          }
        }
      }
    }

    dynamic "user_account" {
      for_each = var.username != null ? [1] : []
      content {
        username = var.username
        password = var.password
        keys     = var.ssh_keys
      }
    }

    # Add SSH keys directly to cloud-init (only if username block doesn't exist)
    dynamic "user_account" {
      for_each = var.username == null && (var.ssh_public_key_rsa != "" || var.ssh_public_key_ed25519 != "") ? [1] : []
      content {
        username = "root"
        keys     = compact([
          var.ssh_public_key_rsa,
          var.ssh_public_key_ed25519
        ])
      }
    }
  }

  on_boot             = var.on_boot
  reboot_after_update = var.reboot_after_update
  started             = var.started
  pool_id             = var.pool_id

  lifecycle {
    ignore_changes = [
      efi_disk,
      tpm_state,
    ]
  }
}

