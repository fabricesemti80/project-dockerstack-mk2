# Proxmox VM Template Creation

This directory automates the creation of a Debian 13 (Trixie) cloud-init template on Proxmox. This template serves as the base image for all Docker host VMs.

## Overview

```mermaid
flowchart LR
    subgraph "Source"
        IMG["Debian 13 Cloud Image<br/>(Generic AMD64)"]
    end

    subgraph "Processing"
        LGF["libguestfs-tools"]
        QGA["QEMU Guest Agent<br/>Injection"]
    end

    subgraph "Proxmox"
        TPL["VM Template<br/>ID: 9008"]
        VMs["Clone to VMs"]
    end

    IMG --> LGF
    LGF --> QGA
    QGA --> TPL
    TPL --> VMs

    classDef source fill:#2196f3,stroke:#fff,color:#fff
    classDef process fill:#ff9800,stroke:#fff,color:#fff
    classDef proxmox fill:#e65100,stroke:#fff,color:#fff

    class IMG source
    class LGF,QGA process
    class TPL,VMs proxmox
```

## Prerequisites

- Proxmox VE with SSH access (as root)
- [Doppler CLI](https://docs.doppler.com/docs/install-cli) installed
- [Ansible](https://docs.ansible.com/ansible/latest/installation_guide/) installed (for local execution)
- [Task](https://taskfile.dev/installation/) installed

## Required Secrets (Doppler)

| Secret Name | Description | Example |
|:---|:---|:---|
| `PROXMOX_HOST` | IP address or hostname of the Proxmox node | `10.0.40.10` |
| `ADMIN_PASSWORD` | Password for the default user in cloud-init | `securepassword123` |
| `TF_VAR_SSH_PUBLIC_KEYS` | JSON list of SSH public keys | `["ssh-rsa AAAA...", "ssh-ed25519 AAAA..."]` |
| `ANSIBLE_SSH_PRIVATE_KEY` | Private SSH key to access Proxmox host | `-----BEGIN OPENSSH PRIVATE KEY-----...` |
| `ANSIBLE_SSH_USER` | Username for the template's default user | `fs` |

## Template Specifications

| Property | Value |
|:---|:---|
| Template ID | `9008` |
| Base Image | Debian 13 (Trixie) Generic Cloud AMD64 |
| Storage | `vm-storage` |
| Features | Cloud-init, QEMU Guest Agent pre-installed |
| Default User | Configured via `ANSIBLE_SSH_USER` |

## Directory Structure

```
01_proxmox_template/
├── ansible/
│   ├── playbook.yml         # Main playbook
│   ├── roles/               # Ansible roles (if any)
│   └── files/               # Static files
├── SETUP.md                 # This file
└── Taskfile.yml             # Task automation
```

## Usage

### Option 1: Local Execution

Run the playbook using your local Ansible installation:

```bash
# Configure Doppler
doppler setup

# Create the template
task create_template
```

### Option 2: GitHub Actions (Automated)

The workflow `.github/workflows/proxmox-template.yml` runs automatically on your self-hosted runner.

**Triggers:**
- Push to `main` branch affecting `01_proxmox_template/` directory
- Manual trigger via `workflow_dispatch`

**Requirements:**
- `DOPPLER_TOKEN` secret set in GitHub repository settings
- Self-hosted runner with labels: `self-hosted`, `proxmox`, `docker`

The workflow runs Ansible inside a Docker container (`willhallonline/ansible`) for consistency and isolation.

## What the Playbook Does

1. **Downloads Debian 13 Cloud Image**
   - Source: Official Debian cloud images
   - Format: QCOW2

2. **Injects QEMU Guest Agent**
   - Uses `libguestfs-tools` (specifically `virt-customize`)
   - Installs `qemu-guest-agent` package directly into the image
   - Enables proper VM monitoring and graceful shutdown

3. **Creates Proxmox VM**
   - Imports the customized disk
   - Configures cloud-init settings
   - Converts to template

4. **Configures Cloud-Init**
   - Sets default username and password
   - Injects SSH public keys
   - Configures network (DHCP or static)

## Template Customization

To modify the template configuration, edit `ansible/playbook.yml`:

```yaml
# Change template ID
template_vm_id: 9008

# Change storage location
storage: "vm-storage"

# Change base image
debian_cloud_image_url: "https://cloud.debian.org/images/cloud/trixie/..."
```

## Verification

After template creation:

1. **Check in Proxmox UI:**
   - Navigate to Datacenter → pve-2 → VM Templates
   - Verify template `9008` exists

2. **Test Clone:**
   ```bash
   # From Proxmox shell
   qm clone 9008 9999 --name test-clone --full
   qm start 9999
   ```

3. **Verify Guest Agent:**
   ```bash
   # After VM boots
   qm agent 9999 ping
   ```

## Troubleshooting

| Issue | Cause | Solution |
|:---|:---|:---|
| `virt-customize` fails | libguestfs not installed | `apt install libguestfs-tools` on Proxmox |
| Template already exists | Previous run didn't clean up | Delete existing template: `qm destroy 9008` |
| SSH connection refused | Wrong credentials | Verify `PROXMOX_HOST` and SSH keys |
| Cloud-init not working | Missing cloud-init disk | Ensure playbook creates cloud-init drive |

## Notes

- The playbook uses `libguestfs-tools` to inject the QEMU guest agent directly into the image before importing it to Proxmox
- This approach ensures the guest agent is available on first boot
- Template ID `9008` is chosen to avoid conflicts with running VMs (typically 100-999)

## Next Steps

After template creation:

1. **Deploy VMs:** `cd ../10_infra_deployment && task apply`
2. **Configure VMs:** `cd ../11_infra_configuration && task apply`
