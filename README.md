# OpenCode Podman Sandbox (`opencode-podman-sandbox`)

A secure, containerized sandbox environment running **OpenCode AI CLI** alongside a strict egress proxy (**Squid**) and an AI proxy/token manager (**Headroom**). Designed to safely run autonomous coding agents with restricted network access and strict system-level isolation using **Podman**.

---

## Architecture & Security Features

* **Network Isolation**: Containers run on an internal-only network (`internal_only`). The Squid proxy acts as the sole gateway to allow egress traffic *only* to pre-approved domains (e.g., OpenRouter, Anthropic).
* **Non-Root Execution**: The OpenCode CLI runs under an unprivileged user (`opencode`, UID 1000).
* **Hardened Containers**: Capabilities are dropped (`cap_drop: ALL`), root privilege escalation is blocked (`no-new-privileges:true`), and resource limits (CPU/Memory/PIDs) are enforced.
* **Isolated Workspace**: Only the folder specified in your environment configuration is mounted into the container.

---

## Prerequisites

* **Podman** installed on your host machine.
* **Podman-compose** (or Podman's Docker-compose compatibility layer).

---

## Configuration

1. Copy or configure your environment variables in `.env` and `.env.local`:
   * Set `WORKSPACE_DIR` in your `.env` file to point to the local project directory you want the agent to work on.
   * Store any sensitive API keys or local configurations inside `.env.local` or `opencode.jsonc.local` (which are ignored by Git).

2. Review the allowed outbound domains in `squid.conf` if your agent needs access to extra services (e.g., PyPI, GitHub, Hugging Face).

---

## Usage Commands

### 1. Build the Container Image
Build the local OpenCode container image using Podman:
```bash
podman-compose build
```

### 2. Start the Sandbox
Start all services in detached mode:
```bash
podman-compose up -d
```

### 3. Access the OpenCode CLI Interface
To attach to the running OpenCode interactive container:
```bash
podman attach opencode
```
*(Tip: Press `Ctrl+P` then `Ctrl+Q` to detach without stopping the container).*

### 4. Stop the Sandbox
To stop and clean up the services:
```bash
podman-compose down
```

---

## Security Notes
* **Never commit `.env.local` or `opencode.jsonc.local`** to public repositories, as they contain sensitive tokens/API keys.