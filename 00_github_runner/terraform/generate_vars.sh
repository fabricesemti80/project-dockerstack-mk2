#!/bin/bash
set -e

# Generate .proxmox.tfvars.json securely
# Expects TF_VAR_SSH_PUBLIC_KEYS to be set in the environment

if [ -z "$TF_VAR_SSH_PUBLIC_KEYS" ]; then
    echo "Error: TF_VAR_SSH_PUBLIC_KEYS is not set."
    exit 1
fi

if [ -z "$ANSIBLE_SSH_USER" ]; then
    echo "Error: ANSIBLE_SSH_USER is not set."
    exit 1
fi

cat <<EOF > .proxmox.tfvars.json
{
  "ssh_public_keys": $TF_VAR_SSH_PUBLIC_KEYS,
  "ci_user": "$ANSIBLE_SSH_USER"
}
EOF
