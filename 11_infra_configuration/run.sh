#!/bin/bash
set -e

# This script runs ansible-playbook with secrets from Doppler.
# It handles creating a temporary SSH private key file.

PLAYBOOK="playbooks/main.yml"
INVENTORY="inventory/hosts"

if [ -z "$ANSIBLE_SSH_PRIVATE_KEY" ]; then
    echo "Error: ANSIBLE_SSH_PRIVATE_KEY is not set. Are you running with 'doppler run --'?"
    exit 1
fi

# Create a temporary file for the SSH private key
KEY_FILE=$(mktemp /tmp/ansible_key.XXXXXX)
echo "$ANSIBLE_SSH_PRIVATE_KEY" > "$KEY_FILE"
chmod 600 "$KEY_FILE"

# Ensure the temp file is removed on exit
trap 'rm -f "$KEY_FILE"' EXIT

# Run ansible-playbook with all necessary extra-vars
ansible-playbook -i "$INVENTORY" "$PLAYBOOK" \
    --private-key "$KEY_FILE" \
    -u "${ANSIBLE_SSH_USER:-fs}" \
    -e "ci_user=${ANSIBLE_SSH_USER}" \
    -e "ssh_public_keys='${TF_VAR_SSH_PUBLIC_KEYS}'" \
    -e "admin_password=${ADMIN_PASSWORD}" \
    -e "secondary_password=${SECONDARY_PASSWORD}" \
    -e "github_runner_token=${GITHUB_RUNNER_TOKEN}" \
    -e "github_personal_access_token=${GITHUB_PERSONAL_ACCESS_TOKEN}" \
    -e "apps_domain=${DOMAIN}" \
    -e "domain_ops=${DOMAIN_OPS}" \
    -e "domain_media=${DOMAIN_MEDIA}" \
    "$@"
