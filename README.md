```zig
# vibe.sh 😽
# Isolation jail for Mistral Vibe agent on Linux.

# 🛡️ Isolation
- Jail: Agent accesses only `$JAIL_PATH` (mounted at `/app`).
- Identity: Runs as host $UID to avoid root-owned files.
- Toolchain: Vibe, Deno 2.7, Elixir/Mix.
- Persistence: API keys/sessions in `.vibe_config/`.
- DooD: Docker-out-of-Docker for test containers.

# 🚀 Setup
1. Install Docker & Compose v2 (Debian):
   $ sudo apt update && sudo apt install -y docker.io docker-compose-v2
   $ sudo usermod -aG docker $USER  # Logout/login required

2. Clone and set execute bit:
   $ git clone git@github.com:csmr/vibe.sh.git && cd vibe.sh
   $ chmod +x vibe.sh

3. Configure default working directory:
   Edit `vibe.sh` line with `export JAIL_PATH=` to set repo path.

# 🛠️ Usage
All arguments pass directly to Vibe.

## Initialize
$ ./vibe.sh --setup

## Resume Session
$ ./vibe.sh --continue
$ ./vibe.sh --resume <session_id>

## Override Path
$ ./vibe.sh --jaildir=/path/to/project

# Principles
`vibe.sh` sets container config with working directory and container mountpoint, builds Vibe and devtools Dockerfile image, and runs the image as a compose service with Vibe as entrypoint. Agent operates within isolated container filesystem, and can control containers.

# Disclaimer
No affiliation with Mistral or Vibe. No guarantees.
Casimir Pohjanraito 2026
```
