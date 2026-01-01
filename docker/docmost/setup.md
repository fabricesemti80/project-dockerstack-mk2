# Docmost Setup

## Environment Variables

The following secrets must be present in Doppler (or your `.env` file) for the stack to deploy correctly:

| Variable | Description |
| :--- | :--- |
| `DOCMOST_APP_SECRET` | A long random secret key (min 32 chars). Generate with `openssl rand -hex 32`. |
| `DOCMOST_POSTGRES_PASSWORD` | Strong password for the PostgreSQL database. |

## Storage Directories

Ensure the following directories exist on the Proxmox hosts (CephFS mount):

*   `/data/homelab/docker-data/docmost/storage`
*   `/data/homelab/docker-data/docmost/postgres`
*   `/data/homelab/docker-data/docmost/redis`

## Deployment

Deploy using the standard stack deployment script or:

```bash
docker stack deploy -c docker/docmost/docmost-stack.yml docmost
```
