# Beszel Monitoring Setup Guide

[Beszel](https://www.beszel.dev/) is a lightweight server monitoring tool with a Hub-Agent architecture.

## 1. Hub Initialization

The Hub is deployed automatically via Terraform on the cloud leader node.

1.  Access the Beszel UI at `https://beszel.${DOMAIN}`.
2.  Create your initial administrator account.
3.  Click **Add System**.
4.  Copy the **Agent Public Key** (starts with `ssh-ed25519...`).
5.  Save this key in Doppler as `BESZEL_AGENT_KEY`.

## 2. Agent Deployment

The Agents are deployed as a `global` Swarm service. Once you have saved the `BESZEL_AGENT_KEY` in Doppler, re-run the Terraform apply to update the agents with the correct key.

```bash
cd 20_app_deployment && task apply
```

## 3. Adding Nodes to Hub

Since the agents use `mode: host` for networking, they are reachable at the node's IP address on port `45876`.

In the Beszel Hub, add each node:
- **Name:** (e.g., dkr-srv-0)
- **Host:** (Node IP address - use Tailscale IP for secure internal communication)
- **Port:** 45876

## 4. Troubleshooting

- **Agent not connecting:** Ensure the `BESZEL_AGENT_KEY` in Doppler matches exactly the key provided by your Hub instance.
- **Metrics missing:** The agent requires access to the Docker socket. Ensure the volume mount `/var/run/docker.sock:/var/run/docker.sock:ro` is active.
