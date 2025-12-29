# Proxmox Template Creation

This directory contains the automation to create a Debian 13 Cloud-Init template on Proxmox.

## Required Secrets (Doppler)

| Secret Name | Description | Example |
| :--- | :--- | :--- |
| `PROXMOX_HOST` | IP address or hostname of the Proxmox node where the template will be created. | `10.0.40.10` |
| `TEMPLATE_PASSWORD` | Password for the default user (`fs`) in the cloud-init template. | `securepassword` |
| `TF_VAR_SSH_PUBLIC_KEYS` | JSON list of SSH public keys to inject into the template. | `["ssh-rsa ..."]` |
| `ANSIBLE_SSH_PRIVATE_KEY` | Private key to access the Proxmox host. | `-----BEGIN OPENSSH...` |
| `ANSIBLE_SSH_USER` | SSH Username for the template's default user. | `fs` |

## Usage

### 1. Manual Creation (Local)
Use the `Taskfile` to run the playbook using your local Ansible installation:
```bash
task create_template
```
*Note: This requires Ansible to be installed on your local machine.*

### 2. Automated Creation (GitHub Actions)
The workflow `.github/workflows/proxmox-template.yml` is configured to run on your **self-hosted runner**.
- **Triggers:** Automatically on push to `main` affecting this directory, or manually via `workflow_dispatch`.
- **Environment:** In the automated flow, Ansible runs inside a **Docker container** (`willhallonline/ansible`) to ensure consistency and isolation.
- **Secrets:** Requires `DOPPLER_TOKEN` to be set in GitHub Repository Secrets.

## Notes

- The playbook uses `libguestfs-tools` to inject `qemu-guest-agent` directly into the image before importing it.
- The template ID is set to `9008` by default.
- Storage is set to `vm-storage`.
