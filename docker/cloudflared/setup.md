# Cloudflare Tunnel Setup

This stack deploys `cloudflared` connectors to your Swarm, allowing secure remote access without opening external ports.

## 1. Prerequisites

- A Cloudflare account.
- `traefik` stack already deployed.
- `proxy` network already created (managed via Terraform).

## 2. Create the Tunnel (Manual / Dashboard)

1.  Go to [Cloudflare Zero Trust](https://one.dash.cloudflare.com/).
2.  Navigate to **Networks** > **Tunnels**.
3.  Click **Create a tunnel**.
4.  Select **Cloudflared** connector.
5.  Name it (e.g., `docker-swarm-tunnel`).
6.  **Important:** Copy the tunnel token provided. Store it in Doppler as `CLOUDFLARE_TUNNEL_TOKEN`.

## 3. Deployment

### Terraform / Portainer
The stack is automatically deployed via Terraform pointing to this repository.

- **Stack Name:** `cloudflared`
- **Environment Variables:** `CLOUDFLARE_TUNNEL_TOKEN`

## 4. Routing Traffic (DNS & Ingress)

#### Option A: Wildcard (Recommended)
1.  In the Tunnel configuration (Public Hostnames), add:
    - **Subdomain:** `*`
    - **Domain:** `yourdomain.com`
    - **Service:** `HTTPS`
    - **URL:** `traefik:443`
    - **TLS Settings:** Enable **No TLS Verify**.

#### Option B: Individual Hostnames
1.  Add a Public Hostname for each service (e.g., `whoami.yourdomain.com` -> `https://traefik:443`).

## 5. Troubleshooting: "Too Many Redirects"
Ensure the tunnel points to `https://traefik:443` with `No TLS Verify` enabled if Traefik is set to force HTTPS.
