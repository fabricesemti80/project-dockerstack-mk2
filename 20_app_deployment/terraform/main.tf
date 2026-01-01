/* -------------------------------------------------------------------------- */
/*                                   Locals                                   */
/* -------------------------------------------------------------------------- */
locals {
  domain = var.apps_domain
  tz     = "Europe/London"
  puid   = 1000
  pgid   = 1000

  # Secrets & Configs
  cloudflare_api_token    = var.cloudflare_api_token
  acme_email              = var.acme_email
  cloudflare_tunnel_token = var.cloudflare_tunnel_token
  beszel_agent_key        = var.beszel_agent_key
  beszel_agent_token      = var.beszel_agent_token
  portainer_access_token  = var.portainer_access_token
  homepage_jellyfin_api   = var.homepage_jellyfin_api
  
  # App Specific
  beszel_last_update      = "2025-12-30T17:45:00Z"
}

/* -------------------------------------------------------------------------- */
/*                                  Networks                                  */
/* -------------------------------------------------------------------------- */

/* ----------------- Network for all apps routed via Traefik ---------------- */
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

/* ---------- Network for Docker Socket Proxy connected application --------- */
resource "portainer_docker_network" "socket_proxy" {
  endpoint_id = var.endpoint_id
  name        = "socket_proxy"
  driver      = "overlay"
  scope       = "swarm"
  attachable  = true
  internal    = false
  ingress     = false
  enable_ipv4 = true

  ipam_config {
    subnet = "10.0.200.0/24"
  }

  lifecycle {
    ignore_changes = [
      options
    ]
  }
}

/* -------------------------------------------------------------------------- */
/*                                   Stacks                                   */
/* -------------------------------------------------------------------------- */
resource "portainer_stack" "socket-proxy" {
  endpoint_id               = var.endpoint_id
  name                      = "socket-proxy"
  method                    = "repository"
  deployment_type           = "swarm"
  repository_url            = var.repository_url
  repository_reference_name = var.repository_branch
  file_path_in_repository   = "docker/socket-proxy/socket-proxy-stack.yml"
  force_update              = true
  pull_image                = true
  prune                     = true
  update_interval           = "5m"
  stack_webhook             = true

  env {
    name  = "TZ"
    value = local.tz
  }

  env {
    name  = "PUID"
    value = local.puid
  }

  env {
    name  = "PGID"
    value = local.pgid
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
  force_update              = true
  pull_image                = true
  prune                     = true
  update_interval           = "5m"
  stack_webhook             = true

  env {
    name  = "CLOUDFLARE_API_TOKEN"
    value = local.cloudflare_api_token
  }

  env {
    name  = "ACME_EMAIL"
    value = local.acme_email
  }

  env {
    name  = "DOMAIN"
    value = local.domain
  }

  env {
    name  = "TZ"
    value = local.tz
  }

  env {
    name  = "PUID"
    value = local.puid
  }

  env {
    name  = "PGID"
    value = local.pgid
  }

  depends_on = [portainer_stack.socket-proxy]
}

resource "portainer_stack" "whoami" {
  endpoint_id               = var.endpoint_id
  name                      = "whoami"
  method                    = "repository"
  deployment_type           = "swarm"
  repository_url            = var.repository_url
  repository_reference_name = var.repository_branch
  file_path_in_repository   = "docker/traefik/whoami-stack.yml"
  force_update              = true
  pull_image                = true
  prune                     = true
  update_interval           = "5m"
  stack_webhook             = true

  env {
    name  = "DOMAIN"
    value = local.domain
  }

  env {
    name  = "TZ"
    value = local.tz
  }

  env {
    name  = "PUID"
    value = local.puid
  }

  env {
    name  = "PGID"
    value = local.pgid
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
  force_update              = true
  pull_image                = true
  prune                     = true
  update_interval           = "5m"
  stack_webhook             = true

  env {
    name  = "CLOUDFLARE_TUNNEL_TOKEN"
    value = local.cloudflare_tunnel_token
  }

  env {
    name  = "TZ"
    value = local.tz
  }

  env {
    name  = "PUID"
    value = local.puid
  }

  env {
    name  = "PGID"
    value = local.pgid
  }

  depends_on = [portainer_stack.traefik]
}

resource "portainer_stack" "beszel" {
  endpoint_id               = var.endpoint_id
  name                      = "beszel"
  method                    = "repository"
  deployment_type           = "swarm"
  repository_url            = var.repository_url
  repository_reference_name = var.repository_branch
  file_path_in_repository   = "docker/beszel/beszel-stack.yml"
  force_update              = true
  pull_image                = true
  prune                     = true
  update_interval           = "5m"
  stack_webhook             = true

  env {
    name  = "DOMAIN"
    value = local.domain
  }

  env {
    name  = "BESZEL_AGENT_KEY"
    value = local.beszel_agent_key
  }

  env {
    name  = "BESZEL_AGENT_TOKEN"
    value = local.beszel_agent_token
  }

  env {
    name  = "LAST_UPDATE"
    value = local.beszel_last_update
  }

  env {
    name  = "TZ"
    value = local.tz
  }

  env {
    name  = "PUID"
    value = local.puid
  }

  env {
    name  = "PGID"
    value = local.pgid
  }

  depends_on = [portainer_stack.traefik]
}

resource "portainer_stack" "homepage" {
  endpoint_id               = var.endpoint_id
  name                      = "homepage"
  method                    = "repository"
  deployment_type           = "swarm"
  repository_url            = var.repository_url
  repository_reference_name = var.repository_branch
  file_path_in_repository   = "docker/homepage/homepage-stack.yml"
  force_update              = true
  pull_image                = true
  prune                     = true
  update_interval           = "5m"
  stack_webhook             = true

  env {
    name  = "DOMAIN"
    value = local.domain
  }

  env {
    name  = "PORTAINER_ACCESS_TOKEN"
    value = local.portainer_access_token
  }

  env {
    name  = "TZ"
    value = local.tz
  }

  env {
    name  = "PUID"
    value = local.puid
  }

  env {
    name  = "PGID"
    value = local.pgid
  }

  depends_on = [portainer_stack.traefik]
}

resource "portainer_stack" "glance" {
  endpoint_id               = var.endpoint_id
  name                      = "glance"
  method                    = "repository"
  deployment_type           = "swarm"
  repository_url            = var.repository_url
  repository_reference_name = var.repository_branch
  file_path_in_repository   = "docker/glance/glance-stack.yml"
  force_update              = true
  pull_image                = true
  prune                     = true
  update_interval           = "5m"
  stack_webhook             = true

  env {
    name  = "DOMAIN"
    value = local.domain
  }

  env {
    name  = "TZ"
    value = local.tz
  }

  env {
    name  = "PUID"
    value = local.puid
  }

  env {
    name  = "PGID"
    value = local.pgid
  }

  depends_on = [portainer_stack.traefik]
}

resource "portainer_stack" "docker-gc" {
  endpoint_id               = var.endpoint_id
  name                      = "docker-gc"
  method                    = "repository"
  deployment_type           = "swarm"
  repository_url            = var.repository_url
  repository_reference_name = var.repository_branch
  file_path_in_repository   = "docker/docker-gc/docker-gc-stack.yml"
  force_update              = true
  pull_image                = true
  prune                     = true
  update_interval           = "5m"
  stack_webhook             = true

  env {
    name  = "TZ"
    value = local.tz
  }

  env {
    name  = "PUID"
    value = local.puid
  }

  env {
    name  = "PGID"
    value = local.pgid
  }

  depends_on = [portainer_stack.traefik]
}

resource "portainer_stack" "jellyfin" {
  endpoint_id               = var.endpoint_id
  name                      = "jellyfin"
  method                    = "repository"
  deployment_type           = "swarm"
  repository_url            = var.repository_url
  repository_reference_name = var.repository_branch
  file_path_in_repository   = "docker/jellyfin/jellyfin-stack.yml"
  force_update              = true
  pull_image                = true
  prune                     = true
  update_interval           = "5m"
  stack_webhook             = true

  env {
    name  = "DOMAIN"
    value = local.domain
  }

  env {
    name  = "TZ"
    value = local.tz
  }

  env {
    name  = "PUID"
    value = local.puid
  }

  env {
    name  = "PGID"
    value = local.pgid
  }

  env {
    name  = "JELLYFIN_API_KEY"
    value = local.homepage_jellyfin_api
  }

  depends_on = [portainer_stack.traefik]
}