#!/bin/bash
set -e

# Generate .proxmox.tfvars.json securely
# Expects TF_VAR_SSH_PUBLIC_KEYS to be set in the environment

if [ -z "$TF_VAR_SSH_PUBLIC_KEYS" ]; then
    echo "Error: TF_VAR_SSH_PUBLIC_KEYS is not set."
    exit 1
fi

cat <<EOF > .proxmox.tfvars.json
{
  "ssh_public_keys": $TF_VAR_SSH_PUBLIC_KEYS
}
EOF
