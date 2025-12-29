# Doppler Configuration for GitHub Runner

This project uses [Doppler](https://doppler.com) to manage secrets and configuration.
Ensure you have the Doppler CLI installed and configured.

## Required Secrets

Create the following secrets in your Doppler project config (e.g., `dev`):

| Secret Name | Description | Example Format |
| :--- | :--- | :--- |
| `PROXMOX_VE_API_TOKEN` | Proxmox API Token for Terraform authentication. | `root@pam!terraform=xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx` |
| `TF_VAR_ssh_public_keys` | JSON list of SSH public keys to inject into the VM. | `["ssh-rsa AAAA...", "ssh-ed25519 AAAA..."]` |
| `ANSIBLE_SSH_PRIVATE_KEY` | Private SSH key matching one of the public keys. Used by Ansible. | `-----BEGIN OPENSSH PRIVATE KEY-----...` |
| `ANSIBLE_SSH_USER` | SSH Username for connection (e.g., `fs`). | `fs` |
| `REPO_URL` | The GitHub repository or organization URL for the runner. | `https://github.com/my-org/my-repo` |
| `RUNNER_TOKEN` | The GitHub Runner **Registration Token**. Get this from `Settings > Actions > Runners > New self-hosted runner`. | `A1B2C3D4E5...` |

## Usage

1. **Setup Doppler:**
   ```bash
   doppler setup
   ```

2. **Run Tasks:**
   The `Taskfile.yml` automatically wraps commands with `doppler run --`.
   ```bash
   task init
   task apply
   task provision
   ```

## Notes

- **Proxmox Endpoint:** Defaults to `https://10.0.40.10:8006/`. To override, set `TF_VAR_proxmox_endpoint`.
- **Node Name:** Defaults to `pve-2`. To override, set `TF_VAR_node_name`.
