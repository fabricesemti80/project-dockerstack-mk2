#!/bin/bash
set -e

# This script is called by Taskfile to provision the runner.
# It expects to be run with 'doppler run --'

TF_DIR="../terraform"
ANSIBLE_DIR="." # We are in ansible/ directory when this is called

IP=$(cd "$TF_DIR" && terraform output -raw vm_ipv4_address 2>/dev/null || echo "")
if [ -z "$IP" ]; then
  echo "Could not get IP from Terraform output. Please provide IP=x.x.x.x"
  exit 1
fi

# Create temp private key from Doppler secret
if [ -z "$ANSIBLE_SSH_PRIVATE_KEY" ]; then
  echo "Error: ANSIBLE_SSH_PRIVATE_KEY secret is missing in Doppler."
  exit 1
fi
if [ -z "$ANSIBLE_SSH_USER" ]; then
  echo "Error: ANSIBLE_SSH_USER secret is missing in Doppler."
  exit 1
fi

KEY_FILE=$(mktemp)
echo "$ANSIBLE_SSH_PRIVATE_KEY" > "$KEY_FILE"
chmod 600 "$KEY_FILE"
trap "rm -f $KEY_FILE" EXIT

echo "Provisioning runner at $IP..."

# Wait for SSH to be fully ready
count=0
retries=30
echo "Waiting for SSH connection to $ANSIBLE_SSH_USER@$IP..."
until ssh -i "$KEY_FILE" -o ConnectTimeout=5 -o BatchMode=yes -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null $ANSIBLE_SSH_USER@$IP exit 0 2>/dev/null; do
  count=$((count+1))
  if [ $count -ge $retries ]; then
    echo "Timeout waiting for SSH access to $IP. Verify SSH keys and network."
    exit 1
  fi
  echo "Waiting for SSH... ($count/$retries)"
  sleep 10
done

# Run Ansible
ansible-playbook -i "$IP," playbook.yml --private-key "$KEY_FILE" -u "$ANSIBLE_SSH_USER" -e "repo_url=$REPO_URL" -e "github_token=$RUNNER_TOKEN"

echo "Waiting for runner to reboot and come online..."
sleep 45

# Verification Loop
count=0
retries=20
echo "Verifying runner service status..."
until ssh -i "$KEY_FILE" -o ConnectTimeout=5 -o StrictHostKeyChecking=no $ANSIBLE_SSH_USER@$IP "sudo systemctl is-active --quiet actions.runner.*"; do
  count=$((count+1))
  if [ $count -ge $retries ]; then
    echo "Runner service failed to start or is not active."
    ssh -i "$KEY_FILE" -o StrictHostKeyChecking=no $ANSIBLE_SSH_USER@$IP "sudo systemctl status actions.runner.*" || true
    exit 1
  fi
  echo "Waiting for service to be active... ($count/$retries)"
  sleep 15
done

echo "Runner Provisioning Complete & Verified!"
