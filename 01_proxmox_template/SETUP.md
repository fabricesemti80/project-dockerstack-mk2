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

1.  **Configure Secrets:** Ensure the above secrets are in your Doppler project.
2.  **Run Task:**
    ```bash
    task create_template
    ```

## Notes

- The playbook uses `libguestfs-tools` to inject `qemu-guest-agent` directly into the image before importing it.
- The template ID is set to `9008` by default.
- Storage is set to `vm-storage`.
