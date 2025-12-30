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

resource "portainer_stack" "traefik" {
  endpoint_id               = var.endpoint_id
  name                      = "traefik"
  method                    = "repository"
  deployment_type           = "swarm"
  repository_url            = var.repository_url
  repository_reference_name = var.repository_branch
  file_path_in_repository   = "docker/traefik/traefik-stack.yml"

  env {
    name  = "CLOUDFLARE_API_TOKEN"
    value = var.cloudflare_api_token
  }

  env {
    name  = "ACME_EMAIL"
    value = var.acme_email
  }

  env {
    name  = "DOMAIN"
    value = var.apps_domain
  }
}

resource "portainer_stack" "whoami" {
  endpoint_id               = var.endpoint_id
  name                      = "whoami"
  method                    = "repository"
  deployment_type           = "swarm"
  repository_url            = var.repository_url
  repository_reference_name = var.repository_branch
  file_path_in_repository   = "docker/traefik/whoami-stack.yml"

  env {
    name  = "DOMAIN"
    value = var.apps_domain
  }

  depends_on = [portainer_stack.traefik]
}

resource "portainer_stack" "cloudflared" {
  endpoint_id               = var.endpoint_id
  name                      = "cloudflared"
  method                    = "repository"
  deployment_type           = "swarm"
  repository_url            = var.repository_url
  repository_reference_name = var.repository_branch
  file_path_in_repository   = "docker/cloudflared/cloudflared-stack.yml"

  env {
    name  = "CLOUDFLARE_TUNNEL_TOKEN"
    value = var.cloudflare_tunnel_token
  }

  depends_on = [portainer_stack.traefik]
}
