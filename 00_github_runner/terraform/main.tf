resource "proxmox_virtual_environment_vm" "runner" {
  name      = var.vm_name
  node_name = var.node_name
  vm_id     = 4006

  clone {
    vm_id = var.template_vm_id
    full  = true
  }

  agent {
    enabled = false
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
    datastore_id = "vm-storage"
    ip_config {
      ipv4 {
        address = "10.0.40.6/24"
        gateway = "10.0.40.1"
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
  value = "10.0.40.6"
}
