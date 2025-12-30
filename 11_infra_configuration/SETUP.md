# Infrastructure Configuration (Ansible)

This directory contains the Ansible playbooks and roles to configure the deployed infrastructure.

## Required Secrets (Doppler)

Ensure the following secrets are available in your Doppler project. The `Taskfile` will automatically inject them into the Ansible environment.

| Secret Name | Description |
| :--- | :--- |
| `ANSIBLE_SSH_USER` | The primary administrator user (maps to `ci_user`). |
| `TF_VAR_SSH_PUBLIC_KEYS` | JSON list of SSH public keys to authorize. |
| `ADMIN_PASSWORD` | Password for the primary administrator user. |
| `SECONDARY_PASSWORD` | Password for the secondary user (`hacstac`). |
| `PORTAINER_ADMIN_PASSWORD` | Password for Portainer admin user initialization. |
| `TAILSCALE_AUTH_KEY` | Tailscale Authentication Key for node linking. |
| `GITHUB_PERSONAL_ACCESS_TOKEN` | (Optional) GitHub PAT for checking Neovim releases. |
| `DOMAIN` | Main domain for applications (maps to `apps_domain`). |
| `DOMAIN_OPS` | Domain for operations/management services. |
| `DOMAIN_MEDIA` | Domain specifically for media services. |

## Configuration Details

### NFS Media Share
The configuration includes an NFS mount for media content.
- **Server:** `10.0.40.2`
- **Share:** `/media`
- **Mount Point:** `/data/media`
- **Restriction:** This mount is only applied to hosts in the `proxmox_vms` group.

### Storage
- The `storage_setup` role attempts to detect the largest additional disk and configure it using LVM at `/data`.
- For Proxmox VMs, this is typically the 30GB secondary disk.

## Usage

1.  **Initialize:**
    Install required Ansible collections.
    ```bash
    task init
    ```

2.  **Plan (Dry Run):**
    Run the playbook in check mode to see pending changes.
    ```bash
    task plan
    ```

3.  **Apply:**
    Apply the configuration to all servers.
    ```bash
    task apply
    ```
