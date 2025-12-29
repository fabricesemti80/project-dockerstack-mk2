#!/bin/bash
TF_DIR="../terraform"
IP=$(cd "$TF_DIR" && terraform output -raw vm_ipv4_address 2>/dev/null || echo "")
if [ -z "$ANSIBLE_SSH_USER" ]; then
  echo "Error: ANSIBLE_SSH_USER secret is missing in Doppler."
  exit 1
fi

KEY_FILE=$(mktemp)
echo "$ANSIBLE_SSH_PRIVATE_KEY" > "$KEY_FILE"
chmod 600 "$KEY_FILE"
ssh -i "$KEY_FILE" -o StrictHostKeyChecking=no $ANSIBLE_SSH_USER@$IP "sudo systemctl status actions.runner.*"
rm -f "$KEY_FILE"
