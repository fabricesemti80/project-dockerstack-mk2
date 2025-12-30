resource "local_file" "ansible_inventory" {
  filename = "../11_infra_configuration/inventory/hosts"
  content  = <<-EOT

[proxmox_vms]
${module.dkr_srv_1.vm_name} ansible_host=${split("/", module.dkr_srv_1.vm_ipv4_address)[0]}
${module.dkr_srv_2.vm_name} ansible_host=${split("/", module.dkr_srv_2.vm_ipv4_address)[0]}
${module.dkr_srv_3.vm_name} ansible_host=${split("/", module.dkr_srv_3.vm_ipv4_address)[0]}

[cloud_vms]
${module.dkr_srv_0.server_name} ansible_host=${module.dkr_srv_0.server_ipv4_address}

[vms:children]
proxmox_vms
cloud_vms

[swarm_managers:children]
proxmox_vms
cloud_vms

[all:children]
vms

[all:vars]
ansible_user=${var.ci_user}
ansible_ssh_private_key_file=~/.ssh/fs_home_rsa
EOT
}
