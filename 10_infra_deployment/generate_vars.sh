#!/bin/bash
set -e

# Generate .terraform.tfvars.json securely
# Expects variables to be set in the environment via Doppler

# Helper function to check if a variable is set
check_var() {
    if [ -z "${!1}" ]; then
        echo "Error: $1 is not set in environment."
        exit 1
    fi
}

check_var "TF_VAR_SSH_PUBLIC_KEYS"
check_var "HCLOUD_TOKEN"
check_var "PROXMOX_VE_API_TOKEN"
check_var "CLOUDFLARE_API_TOKEN"
check_var "CLOUDFLARE_ACCOUNT_ID"
check_var "CLOUDFLARE_ZONE_ID"
check_var "ANSIBLE_SSH_USER"
check_var "DOPPLER_PROJECT"
check_var "DOPPLER_CONFIG"

cat <<EOF > .terraform.tfvars.json
{
  "ssh_public_keys": $TF_VAR_SSH_PUBLIC_KEYS,
  "ci_user": "$ANSIBLE_SSH_USER",
  "doppler_project": "$DOPPLER_PROJECT",
  "doppler_config": "$DOPPLER_CONFIG",
  "HCLOUD_TOKEN": "$HCLOUD_TOKEN",
  "PROXMOX_VE_API_TOKEN": "$PROXMOX_VE_API_TOKEN",
  "CLOUDFLARE_API_TOKEN": "$CLOUDFLARE_API_TOKEN",
  "CLOUDFLARE_ACCOUNT_ID": "$CLOUDFLARE_ACCOUNT_ID",
  "CLOUDFLARE_ZONE_ID": "$CLOUDFLARE_ZONE_ID"
}
EOF
