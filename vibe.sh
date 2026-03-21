#!/bin/bash

set -e

# default working directory path, aka jail path
export JAIL_PATH="${HOME}/Mutonex/repository"

# target mount path, in container filesystem
export bind_path="/app"

# vibe.sh script location
vibesh_path="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

str_arr=("vibe.sh 😽 isolation container runner")
args=()
# Order-independent parsing
while [[ "$#" -gt 0 ]]; do
    case $1 in
        --jailpath=*)
            export JAIL_PATH="${1#*=}"
            shift
            ;;
        *)
            # Capture all other flags for Vibe
            args+=("$1")
            shift
            ;;
    esac
done
str_arr+=("container volume mount config: "
          "host work path: ${JAIL_PATH}"
          "agent fs mount path: ${bind_path}"
          "vibe args: ${args}")
printf "%s\n" "${str_arr[@]}"

# Sanity check: Docker group
[[ $(groups) =~ "docker" ]] || { echo "Error: $(whoami) not in docker group."; exit 1; }

# Prep local config dir so Docker doesn't make it as root
mkdir -p "${vibesh_path}/.vibe_config"

# Identity exports for the container
export UA_UID=$(id -u)
export UA_GID=$(id -g)

# Build and run
cd "${vibesh_path}" # working dir for docker-compose
source version_audit.sh
docker-compose build mistral-agent
docker-compose run --rm mistral-agent "${args[@]}"
