# contvibe.sh 😽

```bash
Isolation jail for Mistral Vibe agent on Linux.
```

### Description

`contvibe.sh` sets container config with working directory and its container
mountpoint, builds Vibe and devtools `Dockerfile` image with Vibe as
entrypoint, and runs the image using service from `compose.yaml`.

Agent operates within isolated container filesystem, and optionally can
control containers.

Answer to how Vibe would be easy to use for developing
Mutonex game project. Be wary, supervise agent.

### Perks 🛡️

- Jail: Agent accesses only `$JAIL_PATH`, default mount at `/app`.
- Daring: to let agent auto-execute commands in the filesystem.
- Identity: Runs as host $UID to avoid root-owned files.
- Toolchain: Vibe, Deno 2.7, Elixir/Mix.
- Persistence: API keys/sessions in `.vibe_config/`.
- DooD: Docker-out-of-Docker for test containers.

### Quickstart

```bash
# Clone to home directory
cd ~
git clone git@github.com:csmr/contvibe.sh.git
chmod +x contvibe.sh/contvibe.sh

# Add contvibe.sh to env PATH (ie. ~/.bashrc or ~/.zshrc)
export PATH="$HOME/contvibe.sh:$PATH"

# Run from any project directory
cd /path/to/your/project
contvibe.sh --setup --jailpath=/path/to/your/project
```


### Setup 🚀

1. Install Docker & Compose v2 (Debian):
   ```bash
   sudo apt update && sudo apt install -y docker.io docker-compose-v2
   sudo usermod -aG docker $USER  # Logout/login required
   ```

2. Clone and set execute bit:
   ```bash
   git clone git@github.com:csmr/contvibe.sh.git
   chmod +x contvibe.sh/contvibe.sh
   ```

3. Configure

  * Default working directory:
    * Edit `contvibe.sh/contvibe.sh` line with `export JAIL_PATH=` to set repo path.

  * Enable host Docker control from container/make read-only
    * In `contvibe.sh/compose.yaml` section `volumes:`, uncomment line with
      * `- /var/run/docker.sock:/var/run/docker.sock:ro`
      * prevents agents container control while allowing inspection/tests.
    * Disable read-only mode restriction: remove `:ro` postfix
      * Note that agent container control may pose security risks.

### Usage 🛠️

All arguments pass directly to Vibe, except `--jailpath`.

#### Initialize

```bash
./contvibe.sh --setup
```

#### Resume session

```bash
./contvibe.sh --continue
./contvibe.sh --"resume <session_id>"
```

#### Override jail path

```bash
./contvibe.sh --jailpath=/path/to/project
```

### Disclaimer

No affiliation with Mistral or Vibe. No guarantees.

See LICENSE, released under MIT by Casimir Pohjanraito 2026.
