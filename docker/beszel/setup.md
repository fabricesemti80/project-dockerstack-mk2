# Beszel Monitoring Setup Guide (Pull Mode)

[Beszel](https://www.beszel.dev/) is configured here in **Pull Mode** for maximum stability in Docker Swarm.

## 1. Hub Initialization

The Hub is deployed automatically via Terraform on the cloud leader node.

1.  Access the Beszel UI at `https://beszel.${DOMAIN}`.
2.  Create your initial administrator account.
3.  Click **Add System**.
4.  Copy the **Agent Public Key** (starts with `ssh-ed25519...`).
5.  Save this key in Doppler as `BESZEL_AGENT_KEY`.

## 2. Agent Deployment

The Agents are deployed as a `global` Swarm service. Once you have saved the `BESZEL_AGENT_KEY` in Doppler, re-run the Terraform apply to update the agents.

```bash
cd 20_app_deployment && task apply
```

## 3. Adding Nodes to Hub

In the Beszel Hub, add each node manually:
1.  **Name:** (e.g., dkr-srv-0)
2.  **Host:** Use the **Tailscale IP** of the node.
3.  **Port:** 45876
4.  **Push Mode:** OFF.

## 4. Troubleshooting

- **Agent logs show 'no key provided':** Ensure `BESZEL_AGENT_KEY` is set in Doppler and you have run `task apply`.
- **Hub cannot reach Agent:** Verify the Tailscale IP is correct and that port `45876` is accessible between nodes.
