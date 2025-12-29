# Project DockerStack MK2

This repository contains the Infrastructure as Code (IaC) and configuration management for a hybrid homelab environment (Proxmox and Hetzner).

## Automation Strategy

We aim to automate the entire lifecycle of the infrastructure using a **local GitHub Self-Hosted Runner**. This allows GitHub Actions to execute tasks directly on the local network (accessing Proxmox, local VMs, etc.) securely and efficiently.

### Goals

1.  **Bootstrap Runner:** Provision a dedicated VM to host the GitHub Runner.
2.  **VM Templates:** Automate the creation of Proxmox VM templates using Ansible.
3.  **Infrastructure Provisioning:** Use Terraform to deploy VMs on both Proxmox (local) and Hetzner (cloud).
4.  **Configuration Management:** Use Ansible to configure the VMs (OS settings, Docker, etc.).
5.  **Application Deployment:** Deploy Docker stacks and services.

All steps are designed to be runnable **manually** (for development/debugging) and via **GitHub Actions** (for CI/CD).

## Components

### 1. GitHub Runner Setup (`00_github_runner/`)

This directory contains the automation to provision the bootstrap runner.

*   **[Setup Guide](00_github_runner/SETUP.md):** Instructions for setting up secrets and running the initial provision.
*   **Tools:** Terraform (VM creation) + Ansible (Software installation).

### 2. VM Templates (`01_proxmox_template/`)
*   Automated Debian 13 template generation on Proxmox.
*   **[Setup Guide](01_proxmox_template/SETUP.md):** Instructions for template creation.

### 3. Infrastructure (*Upcoming*)
*   Terraform modules for Proxmox and Hetzner resources.

### 4. Configuration (*Upcoming*)
*   Ansible roles for system hardening, Docker setup, and networking.

## Usage

Most directories utilize a `Taskfile.yml` to standardize commands.

### Manual Execution
You can run any task locally from its respective directory:
```bash
# Example: Deploying the runner
cd 00_github_runner
task init
task plan
task apply
task provision

# Example: Creating the VM template
cd 01_proxmox_template
task create_template
```

### Automated Execution (CI/CD)
The project includes GitHub Actions workflows that run on your self-hosted runner:
- **Proxmox Template:** Automatically triggers on changes to `01_proxmox_template/` or can be run manually from the GitHub Actions tab. It executes Ansible within a Docker container to ensure a clean and consistent environment.
