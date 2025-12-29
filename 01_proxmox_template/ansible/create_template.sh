#!/bin/bash
set -e

# Simple script to run Ansible for template creation.
# Relies on Doppler to inject environment variables.

if [ -z "$PROXMOX_HOST" ]; then echo "PROXMOX_HOST not set"; exit 1; fi
if [ -z "$ANSIBLE_SSH_PRIVATE_KEY" ]; then echo "ANSIBLE_SSH_PRIVATE_KEY not set"; exit 1; fi

KEY_FILE=$(mktemp)
echo "$ANSIBLE_SSH_PRIVATE_KEY" > "$KEY_FILE"
chmod 600 "$KEY_FILE"
trap "rm -f $KEY_FILE" EXIT

echo "Running Ansible on $PROXMOX_HOST..."
ansible-playbook -i "$PROXMOX_HOST," playbook.yml --private-key "$KEY_FILE" -u root