# GitHub Self-Hosted Runner Setup

This directory contains the automation to provision a dedicated Proxmox VM to host a GitHub self-hosted runner. This runner enables GitHub Actions to execute tasks directly on your local network, accessing Proxmox, local VMs, and other internal resources.

## Overview

```mermaid
flowchart LR
    subgraph "GitHub"
        GH["GitHub Actions"]
    end

    subgraph "Proxmox"
        VM["Runner VM"]
        PVE["Proxmox API"]
    end

    subgraph "Tools Installed"
        ANS["Ansible"]
        TF["Terraform"]
        DOP["Doppler CLI"]
        DOC["Docker"]
        TSK["Task"]
    end

    GH <-->|"Jobs"| VM
    TF -->|"Create VM"| PVE
    VM --> ANS
    VM --> TF
    VM --> DOP
    VM --> DOC
    VM --> TSK

    classDef github fill:#24292e,stroke:#fff,color:#fff
    classDef proxmox fill:#e65100,stroke:#fff,color:#fff
    classDef tools fill:#4caf50,stroke:#fff,color:#fff

    class GH github
    class VM,PVE proxmox
    class ANS,TF,DOP,DOC,TSK tools
```

## Prerequisites

- Proxmox VE with API access
- [Doppler CLI](https://docs.doppler.com/docs/install-cli) installed locally
- [Terraform](https://www.terraform.io/downloads) installed locally
- [Ansible](https://docs.ansible.com/ansible/latest/installation_guide/) installed locally
- [Task](https://taskfile.dev/installation/) installed locally

## Required Secrets (Doppler)

Create the following secrets in your Doppler project:

| Secret Name | Description | Example |
|:---|:---|:---|
| `PROXMOX_VE_API_TOKEN` | Proxmox API Token for Terraform. Format: `user@realm!tokenid=secret` | `root@pam!terraform=xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx` |
| `TF_VAR_ssh_public_keys` | JSON list of SSH public keys to inject into the VM | `["ssh-rsa AAAA...", "ssh-ed25519 AAAA..."]` |
| `ANSIBLE_SSH_PRIVATE_KEY` | Private SSH key matching one of the public keys | `-----BEGIN OPENSSH PRIVATE KEY-----...` |
| `ANSIBLE_SSH_USER` | SSH username for Ansible connections | `fs` |
| `REPO_URL` | GitHub repository or organization URL for the runner | `https://github.com/my-org` or `https://github.com/my-org/my-repo` |
| `RUNNER_TOKEN` | GitHub Runner registration token | `A1B2C3D4E5...` |

### Getting the Runner Token

1. Go to your GitHub repository or organization
2. Navigate to **Settings** → **Actions** → **Runners**
3. Click **New self-hosted runner**
4. Copy the token from the configuration command

> ⚠️ **Note:** Runner tokens expire after 1 hour. Generate a new token immediately before running `task provision`.

## Configuration

### Default Values

| Setting | Default | Override Variable |
|:---|:---|:---|
| Proxmox Endpoint | `https://10.0.40.10:8006/` | `TF_VAR_proxmox_endpoint` |
| Proxmox Node | `pve-2` | `TF_VAR_node_name` |
| VM ID | Auto-assigned | `TF_VAR_vm_id` |

## Directory Structure

```
00_github_runner/
├── ansible/
│   ├── playbook.yml      # Ansible playbook for runner setup
│   └── inventory/        # Dynamic inventory
├── terraform/
│   ├── main.tf           # VM resource definition
│   ├── variables.tf      # Input variables
│   └── outputs.tf        # Output values
├── SETUP.md              # This file
└── Taskfile.yml          # Task automation
```

## Usage

### Step 1: Configure Doppler

```bash
doppler setup
```

Select your project and config (e.g., `dev`).

### Step 2: Initialize Terraform

```bash
task init
```

### Step 3: Plan (Optional)

Review what will be created:

```bash
task plan
```

### Step 4: Create the VM

```bash
task apply
```

### Step 5: Provision the Runner

```bash
task provision
```

This step:
- Installs essential automation tools (Ansible, Terraform, Task, Doppler CLI)
- Installs Docker
- Downloads and configures the GitHub Actions runner
- Registers the runner with your repository/organization
- Creates a systemd service for the runner

## Verification

After provisioning, verify the runner is registered:

1. Go to your GitHub repository/organization
2. Navigate to **Settings** → **Actions** → **Runners**
3. You should see your new runner with status **Idle**

### SSH into the Runner

```bash
ssh fs@<runner-ip>
```

### Check Runner Service

```bash
sudo systemctl status actions.runner.*.service
```

## Maintenance

### Update Runner Version

The runner auto-updates, but you can manually update:

```bash
ssh fs@<runner-ip>
cd actions-runner
./config.sh --check
```

### Restart Runner Service

```bash
sudo systemctl restart actions.runner.*.service
```

### View Runner Logs

```bash
journalctl -u actions.runner.*.service -f
```

## Troubleshooting

| Issue | Cause | Solution |
|:---|:---|:---|
| Runner not connecting | Expired token | Generate new token and re-run `task provision` |
| SSH connection refused | VM not ready | Wait for cloud-init to complete |
| Terraform auth error | Invalid API token | Verify `PROXMOX_VE_API_TOKEN` format |

## What Gets Installed

The provisioning playbook installs:

| Tool | Purpose |
|:---|:---|
| Ansible | Configuration management for subsequent playbooks |
| Terraform | Infrastructure provisioning |
| Task | Task runner for Taskfile.yml execution |
| Doppler CLI | Secrets management |
| Docker | Container runtime (for containerized workflows) |
| GitHub Actions Runner | Self-hosted runner binary |

## Next Steps

After the runner is operational:

1. **Create VM Template:** `cd ../01_proxmox_template && task create_template`
2. **Deploy Infrastructure:** `cd ../10_infra_deployment && task apply`
3. **Configure Servers:** `cd ../11_infra_configuration && task apply`
