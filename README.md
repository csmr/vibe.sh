```zig
# vibe.sh 😽
# Isolation jail for the Mistral Vibe agent.
# For (Debian) Linux.

# 🛡️ Isolation Hygiene
- container jail : agent only accesses `$JAIL_PATH`, mounted as `/app`.
- identity       : runs as host $UID to prevent root-owned file issues.
- toolchain      : bundles Vibe, Deno 2.7, and Elixir/Mix.
- persistence    : API keys and sessions stored in local .vibe_config/.
- DooD           : "Docker-out-of-Docker" to run sibling test containers.

# 🚀 Setup

1. Install Docker & Compose v2 (Debian):
   $ sudo apt update && sudo apt install -y docker.io docker-compose-v2
   $ sudo usermod -aG docker $USER  # Requires logout/login

2. Clone & Prepare:
   $ cd ~/Mutonex
   $ git clone git@github.com:YOUR_USERNAME/vibe.sh.git && cd vibe.sh
   $ chmod +x vibe.sh

3. Configure default working directory:
   - Edit 'vibe.sh' line with 'export JAIL_PATH=' with your project root path.

# 🛠️ Usage
All arguments are forwarded directly to the Vibe binary.

## Initialize/Setup
$ ./vibe.sh --setup

## Resume Session
$ ./vibe.sh --continue
$ ./vibe.sh --resume <session_id>

## Override Default Path
$ ./vibe.sh --jaildir=/path/to/other/project

# Casimir Pohjanraito 2026
# This project just for convinience. No affiliation to Mistral or Vibe, no ownership or guarantees implied.
```
