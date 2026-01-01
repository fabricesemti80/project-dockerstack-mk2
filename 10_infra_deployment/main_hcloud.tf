data "http" "my_public_ip" {
  url = "https://ipv4.icanhazip.com/"
}

locals {
  my_ip = "${chomp(data.http.my_public_ip.response_body)}/32"

  dkr_srv_0 = {
    name           = "dkr-srv-0"
    image          = "ubuntu-22.04"
    server_type    = "cx23"
    location       = "hel1"
    ssh_public_key = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIDZNMQ9ZBT1pxZCjNHGI9fE3MaFJPy8gOfOjrA+PclVk fs@Fabrices-MBP"
    ssh_key_name   = "id_macbook_fs"
    enable_ipv4    = true
    enable_ipv6    = true
  }

  firewall_rules = [
    {
      direction  = "in"
      protocol   = "tcp"
      port       = "22"
      source_ips = [local.my_ip] #! This restricts acces to only my [all time updated] public IP!
    },
    {
      direction  = "in"
      protocol   = "tcp"
      port       = "80"
      source_ips = [local.my_ip] #! This restricts acces to only my [all time updated] public IP!
    },
    {
      direction  = "in"
      protocol   = "tcp"
      port       = "443"
      source_ips = [local.my_ip] #! This restricts acces to only my [all time updated] public IP!
    },
    # {
    #   direction  = "in"
    #   protocol   = "tcp"
    #   port       = "3000" # dokply UI default port
    #   source_ips = [local.my_ip]
    # },
    # {
    #   direction  = "in"
    #   protocol   = "tcp"
    #   port       = "9120" # komodo
    #   source_ips = [local.my_ip]
    # },
    {
      direction  = "in"
      protocol   = "tcp"
      port       = "9443" # Portainer HTTPs
      source_ips = [local.my_ip]
    },
    {
      direction  = "in"
      protocol   = "tcp"
      port       = "9000" # Portainer HTTP
      source_ips = [local.my_ip]
    } ,
    # {
    #   direction  = "in"
    #   protocol   = "tcp"
    #   port       = "8080" # Test App port
    #   source_ips = [local.my_ip]
    # }
  ]
}

# Hetzner Cloud Server Module
module "dkr_srv_0" {
  source = "./modules/hetzner-cloud"

  # Server Configuration
  server_name    = local.dkr_srv_0.name
  server_image   = local.dkr_srv_0.image
  server_type    = local.dkr_srv_0.server_type
  location       = local.dkr_srv_0.location
  ssh_public_key = local.dkr_srv_0.ssh_public_key
  ssh_key_name   = local.dkr_srv_0.ssh_key_name
  enable_ipv4    = local.dkr_srv_0.enable_ipv4
  enable_ipv6    = local.dkr_srv_0.enable_ipv6

  # Firewall Configuration
  firewall_name  = "dkr-srv-0-fw"
  firewall_rules = local.firewall_rules

  # User data to configure fs user with both SSH keys
  user_data = <<-EOF
#cloud-config
users:
  - name: fs
    sudo: ALL=(ALL) NOPASSWD:ALL
    groups: sudo
    shell: /bin/bash
    ssh_authorized_keys:
      - ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQCpjSKK4qiMx4vIOvX7PHBOOctpYQ/XQQKWinw+v8oIQoI3GWkdRTwZpXJ2QSor/10zk5TZphP6XpfXxJj3caPwZPnu/ZFci/Iy40T6O2PDUFBjzaBLoIRci4lkRgjyEITKt9K1gIiqO8CnrMNBQTYj8gt7pHa3jIv102M1JIVqq4IU6tDTnf6Nku20jQcvxQCuJT0AszLZwMsD8IMOPkOfztnYOeJTXKOvcT+Vff3+ORXtXbVXNvAhobiSdK1MH5dAMsDZs9QcAazJGMfp50BcBUiHCRUo2XRk+IjMt7Tj6EjI+IMy+QOQWvTM016X9xTiLrPEJMU2RatfeG9VvcCPeQxPCbQE7uuYvCa3SAeJ3CTSL6kTE/4gp4uIq/XZEgZZO/4vuWF+1cNRYhePyJm9tlIU1o5AHHL2I8FJUlQJAe/+gRd/irfzRGDhiYw3fa02nFXsPY4mlEjIdjAd7JYRv1D3X2LBS+62PjqRC3NoNLodfywd3pVsiO3l3QsQKMRGxbyA9jSelSORNftGNeIQJWgJXW0ws42aCYmdcarCpLIil5QfV3WSfXz+a+wd5y7OCW19+sl3j1RHJhIuttsAZQOIGisCfDgstxhY08yuqA2DcZCdNL50JJzN2AQyeVzGRNEhFFEELBdRMAOf7L61Qie3Y+s9aN0do0xDInOkYQ== fs@home
      - ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIDZNMQ9ZBT1pxZCjNHGI9fE3MaFJPy8gOfOjrA+PclVk fs@Fabrices-MBP

# # Update packages
# package_update: true
# package_upgrade: true

# runcmd:
#   - echo "Hetzner VM configured with fs user and both SSH keys"
#   - usermod -aG docker fs
#   - echo "fs user added to docker group"
EOF
}

# MANUAL SSH DIAGNOSTIC COMMANDS (run these after server deployment):
# ssh fs@<SERVER_IP> -i ~/.ssh/id_macbook_fs "cat /var/log/tailscale-install.log"
# ssh fs@<SERVER_IP> -i ~/.ssh/id_macbook_fs "which tailscale || echo 'Tailscale not found in PATH'"
# ssh fs@<SERVER_IP> -i ~/.ssh/id_macbook_fs "tailscale status --json"
# ssh fs@<SERVER_IP> -i ~/.ssh/id_macbook_fs "tailscale ip -4 && tailscale ip -6"
# ssh fs@<SERVER_IP> -i ~/.ssh/id_macbook_fs "tailscale capabilities list"
# ssh root@<SERVER_IP> -i ~/.ssh/id_macbook_fs "cat /var/log/tailscale-install.log" (root login available)
