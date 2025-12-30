terraform {
  required_providers {
    portainer = {
      source  = "portainer/portainer"
      version = "~> 1.0"
    }
  }
}

provider "portainer" {
  endpoint = var.portainer_url
  api_key  = var.portainer_access_token
  
  # Skip TLS verification if using HTTP or self-signed certs
  skip_ssl_verify = true
}