# Arr Stack Setup

## Environment Variables

The following secrets must be present in Doppler (or your `.env` file) for the stack to deploy correctly:

| Variable | Description |
| :--- | :--- |
| `AUTOBRR_SESSION_SECRET` | Session secret for Autobrr. |
| `AUTOBRR_POSTGRES_PASSWORD` | Password for Autobrr PostgreSQL database. |
| `RADARR_API_KEY` | API Key for Homepage widget (optional, populate after install). |
| `SONARR_API_KEY` | API Key for Homepage widget (optional, populate after install). |
| `BAZARR_API_KEY` | API Key for Homepage widget (optional, populate after install). |
| `SABNZBD_API_KEY` | API Key for Homepage widget (optional, populate after install). |

## Storage Directories

Ensure the following directories exist on the Proxmox hosts (CephFS mount):

*   `/data/homelab/docker-data/radarr`
*   `/data/homelab/docker-data/sonarr`
*   `/data/homelab/docker-data/bazarr`
*   `/data/homelab/docker-data/sabnzbd`
*   `/data/homelab/docker-data/autobrr`
*   `/data/homelab/docker-data/autobrr/postgres`

## Deployment

Deploy using the standard stack deployment script or via Portainer/Terraform.
