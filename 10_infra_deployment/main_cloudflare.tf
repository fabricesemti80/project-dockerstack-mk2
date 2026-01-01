# Cloudflare Infrastructure: Tunnel and Zero Trust Access

data "cloudflare_zone" "krapulax_dev" {
  zone_id = var.CLOUDFLARE_ZONE_ID
}

locals {
  zone_name = data.cloudflare_zone.krapulax_dev.name

  # List of emails allowed to access authenticated services
  admin_emails = [
    var.ACCESS_EMAIL,
    "gabriellagungl@gmail.com",
    "fabrice.semti@gmail.com",
    "fabrice@fabricesemti.com"
  ]

  # Services that should bypass Cloudflare Access (publicly available)
  public_subdomains = [
    "blog"
  ]
}

/* -------------------------------------------------------------------------- */
/*                              Cloudflare Tunnel                             */
/* -------------------------------------------------------------------------- */

# Generates a random secret for the tunnel (32+ bytes required)
resource "random_id" "tunnel_secret" {
  byte_length = 35
}

resource "cloudflare_zero_trust_tunnel_cloudflared" "main" {
  account_id    = var.CLOUDFLARE_ACCOUNT_ID
  name          = replace(local.zone_name, ".", "_")
  tunnel_secret = random_id.tunnel_secret.b64_std
}

resource "cloudflare_zero_trust_tunnel_cloudflared_config" "main" {
  account_id = var.CLOUDFLARE_ACCOUNT_ID
  tunnel_id  = cloudflare_zero_trust_tunnel_cloudflared.main.id

  config = {
    ingress = [
      {
        hostname = "*.${local.zone_name}"
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

# DNS record for wildcard tunnel
resource "cloudflare_dns_record" "wildcard_tunnel" {
  zone_id = var.CLOUDFLARE_ZONE_ID
  name    = "*"
  content = "${cloudflare_zero_trust_tunnel_cloudflared.main.id}.cfargotunnel.com"
  type    = "CNAME"
  proxied = true
  ttl     = 1
  comment = "Wildcard Tunnel Ingress (Managed by Terraform)"
}

# Construct the Tunnel Token for use in Swarm nodes
locals {
  CLOUDFLARE_TUNNEL_TOKEN = base64encode(jsonencode({
    a = var.CLOUDFLARE_ACCOUNT_ID
    t = cloudflare_zero_trust_tunnel_cloudflared.main.id
    s = random_id.tunnel_secret.b64_std
  }))
}

# Sync the Tunnel Token to Doppler
resource "doppler_secret" "cloudflare_tunnel_token" {
  project = var.doppler_project
  config  = var.doppler_config
  name    = "CLOUDFLARE_TUNNEL_TOKEN"
  value   = local.CLOUDFLARE_TUNNEL_TOKEN
}

/* -------------------------------------------------------------------------- */
/*                           Cloudflare Zero Trust Access                     */
/* -------------------------------------------------------------------------- */

# 1. Main Wildcard Access (Authenticated)
# Protects all subdomains (*.krapulax.dev) behind Google Auth/Email check.
resource "cloudflare_zero_trust_access_application" "lab_wildcard" {
  account_id = var.CLOUDFLARE_ACCOUNT_ID
  name       = "Lab Wildcard Access"
  domain     = "*.${local.zone_name}"
  type       = "self_hosted"

  session_duration          = "24h"
  auto_redirect_to_identity = false

  policies = [
    {
      name       = "Allow Admin"
      decision   = "allow"
      precedence = 1
      include = [
        for email in local.admin_emails : {
          email = {
            email = email
          }
        }
      ]
    }
  ]
}

# 2. Public Service Bypass
# Specific hostnames that bypass authentication (e.g., blog)
resource "cloudflare_zero_trust_access_application" "public_bypass" {
  for_each = toset(local.public_subdomains)

  account_id = var.CLOUDFLARE_ACCOUNT_ID
  name       = "Public Bypass: ${title(each.key)}"
  domain     = "${each.key}.${local.zone_name}"
  type       = "self_hosted"

  policies = [
    {
      name     = "Allow Everyone"
      decision = "bypass"
      include = [
        {
          everyone = {}
        }
      ]
    }
  ]
}
