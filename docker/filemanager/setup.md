# Filemanager Stack Setup

## Environment Variables

The following secrets must be present in Doppler (or your `.env` file) for the stack to deploy correctly:

| Variable | Description |
| :--- | :--- |
| `FILEBROWSER_ADMIN_PASSWORD` | Admin password for Filebrowser. |
| `PERSISTENT_TOKENS_KEY` | Secret key for Filerise persistent tokens. |

## Storage Directories

Ensure the following directories exist on the Proxmox hosts (CephFS mount):

*   `/data/homelab/docker-data/filebrowser`
*   `/data/homelab/docker-data/filerise/users`
*   `/data/homelab/docker-data/filerise/metadata`

## Deployment

Deploy using the standard stack deployment script or via Portainer/Terraform.
