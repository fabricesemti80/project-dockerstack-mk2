resource "proxmox_virtual_environment_vm" "runner" {
  name      = var.vm_name
  node_name = var.node_name
  vm_id     = var.vm_id

  clone {
    vm_id = var.template_vm_id
    full  = true
  }

  agent {
    enabled = true
  }

  cpu {
    cores = 2
    type  = "host"
  }

  memory {
    dedicated = 4096
  }

  disk {
    datastore_id = "vm-storage"
    interface    = "virtio0"
    size         = 32
    iothread     = true
    file_format  = "raw"
  }

  network_device {
    bridge = "vmbr0"
  }

  initialization {
    ip_config {
      ipv4 {
        address = "dhcp"
      }
    }

    user_account {
      username = var.ci_user
      keys     = var.ssh_public_keys
    }
  }

  lifecycle {
    ignore_changes = [
      initialization,
    ]
  }
}

output "vm_ipv4_address" {
  value = flatten(proxmox_virtual_environment_vm.runner.ipv4_addresses)[1] # 0 is usually loopback or link-local in some contexts, but actually ipv4_addresses returns list of ips from agent. 
  # Note: The bpg provider output for ipv4_addresses depends on the QEMU agent.
}
