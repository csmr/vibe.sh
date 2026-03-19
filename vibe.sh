#!/bin/bash

set -e

# default working directory path, aka jail dir
export JAIL_PATH="${HOME}/Mutonex/repository"

# target mount path, in container fs
export bind_path="/app"

PASS_ARGS=()

str_arr=("[ Runner for Vibe isolation container ]"
         "* Override default jail path:"
         "  $ ./vibe.sh --jailpath=/foo/bar" " ")

# Order-independent parsing
while [[ "$#" -gt 0 ]]; do
    case $1 in
        --jailpath=*)
            export JAIL_PATH="${1#*=}"
            shift
            ;;
        *)
            # Capture all other flags for Vibe
            PASS_ARGS+=("$1")
            shift
            ;;
    esac
done
str_arr+=("[ Jail path config: ]" "host path ${JAIL_PATH},"
          "agent fs path ${bind_path}")
printf "😽 %s\n" "${str_arr[@]}"

# Sanity check: Docker group
[[ $(groups) =~ "docker" ]] || { echo "Error: $(whoami) not in docker group."; exit 1; }

# Prep local config dir so Docker doesn't make it as root
mkdir -p .vibe_config

# Identity exports for the container
export UA_UID=$(id -u)
export UA_GID=$(id -g)

# Build and run
docker-compose build mistral-agent
docker-compose run --rm mistral-agent "${PASS_ARGS[@]}"
