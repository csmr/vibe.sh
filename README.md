# vibe.sh 😽

```bash
Isolation jail for Mistral Vibe agent on Linux.
```

### Description

`vibe.sh` sets container config with working directory and its container
mountpoint, builds Vibe and devtools Dockerfile image, and runs the image
as a compose service with Vibe as entrypoint. Agent operates within
isolated container filesystem, and can control containers.

Answer to how Vibe would be easy to use for developing
Mutonex game project. Be wary, supervise agent.

### Perks 🛡️

- Jail: Agent accesses only `$JAIL_PATH`, default mount at `/app`.
- Daring: to let agent auto-execute commands in the filesystem.
- Identity: Runs as host $UID to avoid root-owned files.
- Toolchain: Vibe, Deno 2.7, Elixir/Mix.
- Persistence: API keys/sessions in `.vibe_config/`.
- DooD: Docker-out-of-Docker for test containers.

### Setup 🚀

1. Install Docker & Compose v2 (Debian):
   ```bash
   sudo apt update && sudo apt install -y docker.io docker-compose-v2
   sudo usermod -aG docker $USER  # Logout/login required
   ```

2. Clone and set execute bit:
   ```bash
   git clone git@github.com:csmr/vibe.sh.git && cd vibe.sh
   chmod +x vibe.sh
   ```

3. Configure

  * Default working directory:
    - Edit `vibe.sh` line with `export JAIL_PATH=` to set repo path.

  * Enable host Docker control from container/make read-only
    - In `compose.yaml` section `volumes:`, uncomment line with
      * `- /var/run/docker.sock:...`
    - Note that agent container control may pose security risks.
    - Read-only mode restriction: add `:ro` postfix:
      * `- /var/run/docker.sock:/var/run/docker.sock:ro`
      * prevents agents container control while allowing inspection/tests.

### Usage 🛠️

All arguments pass directly to Vibe.

#### Initialize

```bash
./vibe.sh --setup
```

#### Resume session

```bash
./vibe.sh --continue
./vibe.sh --"resume <session_id>"
```

#### Override jail path

```bash
./vibe.sh --jailpath=/path/to/project
```

### Disclaimer

No affiliation with Mistral or Vibe. No guarantees.

See LICENSE, released under MIT by Casimir Pohjanraito 2026.

