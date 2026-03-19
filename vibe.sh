#!/bin/bash
set -e

echo "Runner for Vibe isolation container..."

# Sanity check: Docker group
[[ $(groups) =~ "docker" ]] || { echo "Error: $(whoami) not in docker group."; exit 1; }

# Prep local config dir so Docker doesn't make it as root
mkdir -p .vibe_config

# Identity exports for the container
export UA_UID=$(id -u)
export UA_GID=$(id -g)

# Build and run
docker-compose build mistral-agent
docker-compose run --rm mistral-agent "$@"
