# Beszel Monitoring Setup Guide

[Beszel](https://www.beszel.dev/) is a lightweight server monitoring tool with a Hub-Agent architecture.

## 1. Hub Initialization

The Hub is deployed automatically via Terraform on the cloud leader node.

1.  Access the Beszel UI at `https://beszel.${DOMAIN}`.
2.  Create your initial administrator account.
3.  Click **Add System**.
4.  Toggle **"Agent is behind a firewall (push mode)"**.
5.  Copy the **Token** (long random string).
6.  Save this token in Doppler as `BESZEL_AGENT_TOKEN`.
7.  (Optional) If you also want to support pull mode, save the **Agent Public Key** as `BESZEL_AGENT_KEY`.

## 2. Agent Deployment

The Agents are deployed as a `global` Swarm service. Once you have saved the `BESZEL_AGENT_TOKEN` in Doppler, re-run the Terraform apply to update the agents.

```bash
cd 20_app_deployment && task apply
```

## 3. Adding Nodes to Hub

In push mode, the agents automatically register with the Hub using the provided token. Ensure `HUB_URL` is correctly set to `https://beszel.${DOMAIN}` in the stack configuration.

## 4. Troubleshooting

- **Agent not connecting:** Check agent logs in Portainer. 
- **Missing TOKEN:** If using `HUB_URL`, the agent *must* have a `TOKEN` set.
- **Metrics missing:** The agent requires access to the Docker socket. Ensure the volume mount `/var/run/docker.sock:/var/run/docker.sock:ro` is active.