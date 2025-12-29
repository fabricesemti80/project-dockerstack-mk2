#!/bin/bash
TF_DIR="../terraform"
IP=$(cd "$TF_DIR" && terraform output -raw vm_ipv4_address 2>/dev/null || echo "")
KEY_FILE=$(mktemp)
echo "$SSH_PRIVATE_KEY" > "$KEY_FILE"
chmod 600 "$KEY_FILE"
ssh -i "$KEY_FILE" -o StrictHostKeyChecking=no fs@$IP "sudo systemctl status actions.runner.*"
rm -f "$KEY_FILE"
