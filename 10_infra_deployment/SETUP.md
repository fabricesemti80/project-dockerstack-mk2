# Server Deployment (Terraform)

This directory contains the main Terraform configuration for deploying the core infrastructure (Proxmox VMs, Hetzner Servers, Cloudflare Tunnels, etc.).

## ⚠️ Important: Local State

Currently, the `terraform.tfstate` file is stored **locally** in this directory.

**TODO:** Migrate to a remote backend (e.g., S3, Consul, or Terraform Cloud) to enable safe collaboration and GitHub Actions execution. Until then, **do not** run this via GitHub Actions, as it will not have access to the state file and may attempt to recreate existing resources.

## Required Secrets (Doppler)

Ensure these are set in your Doppler project. The `Taskfile` and `generate_vars.sh` will automatically map them for Terraform.

| Secret Name | Description |
| :--- | :--- |
| `PROXMOX_VE_API_TOKEN` | API Token for Proxmox. |
| `HCLOUD_TOKEN` | API Token for Hetzner Cloud. |
| `CLOUDFLARE_API_TOKEN` | API Token for Cloudflare. |
| `CLOUDFLARE_ACCOUNT_ID`| Cloudflare Account ID. |
| `CLOUDFLARE_ZONE_ID` | Cloudflare Zone ID. |
| `TF_VAR_SSH_PUBLIC_KEYS` | JSON list of SSH public keys. |
| `ANSIBLE_SSH_USER` | The default user to create on VMs (maps to `ci_user`). |
| `TF_VAR_proxmox_ssh_private_key_file` | Path to the private key for Proxmox provider access. |

## Usage

1.  **Initialize:**
    ```bash
    task init
    ```

2.  **Plan:**
    ```bash
    task plan
    ```
    *Ensure the plan shows **No changes** if you are migrating existing state.*

3.  **Apply:**
    ```bash
    task apply
    ```

## Notes

- **VM IDs:** For critical infrastructure nodes (like `dkr_srv_1`, `dkr_srv_2`, `dkr_srv_3`), we explicitly assign `vm_id` in the Terraform configuration. This prevents Terraform/Proxmox from assigning a new random ID during recreation or updates, ensuring consistency.