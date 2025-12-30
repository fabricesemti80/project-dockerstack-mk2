resource "portainer_docker_network" "proxy" {
  endpoint_id = var.endpoint_id
  name        = "proxy"
  driver      = "overlay"
  scope       = "swarm"
  attachable  = true
  internal    = false
  ingress     = false
  enable_ipv4 = true
  
  ipam_config {
    subnet = "10.0.100.0/24"
  }

  lifecycle {
    ignore_changes = [
      options
    ]
  }
}
