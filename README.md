# contvibe.sh 😽

```bash
Sandbox for Mistral Vibe agent on Linux.
```

### Description

Sandbox container for the Vibe agent, providing strict filesystem isolation
for project development. Optionally, can read/control containers via DooD.

Script `contvibe.sh` sets container config with working directory and
its container mountpoint, builds Vibe and devtools `Dockerfile` image with
Vibe as entrypoint, and runs the image using service from `compose.yaml`.

Answer to how Vibe would be easy to use for developing Mutonex game project.
Be wary, supervise agent.


### Perks 🛡️

- Path-isolation: Agent accesses only `$WORK_PATH`, default mount at `/app`.
- Daring: to let agent auto-execute commands in the filesystem.
- Identity: Runs as host $UID to avoid root-owned files; projects host Git name/email.
- Toolchain: Vibe, Deno, Elixir/Mix, git, curl, vim-tiny, build-essential.
- Persistence: 
  - Shared: API keys/sessions in `.vibe_config/` (global).
  - Local: Tool caches (Deno/Mix) and shell history in `.contvibe/` (project-local).
- DooD: Docker-out-of-Docker for test containers.


### Quickstart

```bash
# Clone and add to PATH
git clone git@github.com:csmr/contvibe.sh.git ~/contvibe.sh
export PATH="$HOME/contvibe.sh:$PATH"

# Run in any project directory
cd /path/to/your/project
contvibe.sh --setup
```


### Setup 🚀

1. Install Docker & Compose v2 (Debian):
   ```bash
   sudo apt update && sudo apt install -y docker.io docker-compose-v2
   sudo usermod -aG docker $USER  # Logout/login required
   ```

2. Clone and set execute bit:
   ```bash
   git clone git@github.com:csmr/contvibe.sh.git ~/contvibe.sh
   chmod +x ~/contvibe.sh/contvibe.sh
   ```

3. Add to PATH (Permanent):
   Add this to your `~/.bashrc` (per-user) or `/etc/profile` (system-wide on Debian):
   ```bash
   export PATH="$HOME/contvibe.sh:$PATH"
   ```
   Then reload: `source ~/.bashrc`

4. Configure

  * Default working directory:
    * Edit `contvibe.sh/contvibe.sh` line with `export WORK_PATH=` to set repo path.

  * Enable host Docker control from container/make read-only
    * Re-run with `docker-cli` added in `Dockerfile` runtime dev tools.
    * In `contvibe.sh/compose.yaml` section `volumes:`, uncomment line with
      * `- /var/run/docker.sock:/var/run/docker.sock:ro`
      * prevents agents container control while allowing inspection/tests.
    * Disable read-only mode restriction: remove `:ro` postfix
      * Note that agent container control may pose security risks.


### Usage 🛠️

All arguments pass directly to Vibe, except `--workpath`.

#### Initialize

```bash
./contvibe.sh --setup
```

#### Resume session

```bash
./contvibe.sh --continue
./contvibe.sh --"resume <session_id>"
```

#### Override work path

```bash
./contvibe.sh --workpath=/path/to/project
```

___

### Disclaimer

No affiliation with Mistral or Vibe. No guarantees.

See LICENSE, released under MIT by Casimir Pohjanraito 2026.
