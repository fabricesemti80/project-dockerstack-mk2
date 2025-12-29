data "cloudflare_zone" "krapulax_dev" {
  zone_id = var.CLOUDFLARE_ZONE_ID
}

# Creates a DNS A record for the Coolify server.
# The `proxied` setting is false (DNS only) to allow direct access to the Coolify UI on port 8000.
# Cloudflare's proxy does not support this port.

#TODO: move this to tunnel when implemented
# resource "cloudflare_record" "coolify_server" {
#   zone_id = data.cloudflare_zone.krapulax_dev.id
#   name    = "coolify"
#   content = module.coolify_server.server_ipv4_address
#   type    = "A"
#   proxied = true
#   ttl     = 1
#   comment = "Managed by Terraform"
# }

# DNS record for ittools subdomain
# resource "cloudflare_record" "ittools" {
#   zone_id = data.cloudflare_zone.krapulax_dev.id
#   name    = "ittools"
#   content = module.coolify_server.server_ipv4_address
#   type    = "A"
#   proxied = true
#   ttl     = 1
#   comment = "Managed by Terraform"
# }

# Cloudflare Tunnel Configuration (Provider v5)
# This file manages the Cloudflare Tunnel, Ingress Rules, and DNS records.

# Generates a random secret for the tunnel (32+ bytes required)
resource "random_id" "tunnel_secret" {
  byte_length = 35
}

resource "cloudflare_zero_trust_tunnel_cloudflared" "main" {
  account_id    = var.CLOUDFLARE_ACCOUNT_ID
  name          = replace(data.cloudflare_zone.krapulax_dev.name, ".", "_")
  tunnel_secret = random_id.tunnel_secret.b64_std
}

resource "cloudflare_zero_trust_tunnel_cloudflared_config" "main" {
  account_id = var.CLOUDFLARE_ACCOUNT_ID
  tunnel_id  = cloudflare_zero_trust_tunnel_cloudflared.main.id

  config = {
    ingress = [
      {
        hostname = "*.${data.cloudflare_zone.krapulax_dev.name}"
        service  = "https://traefik:443"
        origin_request = {
          no_tls_verify = true
        }
      },
      {
        service = "http_status:404"
      }
    ]
  }
}

resource "cloudflare_dns_record" "wildcard_tunnel" {
  zone_id = var.CLOUDFLARE_ZONE_ID
  name    = "*"
  content = "${cloudflare_zero_trust_tunnel_cloudflared.main.id}.cfargotunnel.com"
  type    = "CNAME"
  proxied = true
  ttl     = 1 # Required for proxied records
  comment = "Wildcard Tunnel Ingress (Managed by Terraform)"
}

# Construct the Tunnel Token manually since it might not be exported by the resource
locals {
  tunnel_token = base64encode(jsonencode({
    a = var.CLOUDFLARE_ACCOUNT_ID
    t = cloudflare_zero_trust_tunnel_cloudflared.main.id
    s = random_id.tunnel_secret.b64_std
  }))
}

# Output the Tunnel Token to a local .env file for Docker/Portainer use
resource "local_file" "tunnel_env" {
  content         = "TUNNEL_TOKEN=${local.tunnel_token}"
  filename        = "${path.module}/../docker/cloudflared/.env"
  file_permission = "0600"
}
