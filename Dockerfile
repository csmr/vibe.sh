FROM python:3.12-slim-bookworm

# Vibe isolation

# Install Elixir, Deno dependencies, and Docker CLI
RUN apt-get update && apt-get install -y \
    curl unzip elixir docker.io \
    && rm -rf /var/lib/apt/lists/*

# Install Deno 2.7.0
RUN curl -fsSL https://deno.land/install.sh | sh -s v2.7.0
ENV PATH="/root/.local/bin:/root/.deno/bin:$PATH"

# Install mistral-vibe
RUN pip install mistral-vibe

# Create home/work dirs and set permissive access for the jail
RUN mkdir -p /home/python/.vibe /app && chmod -R 777 /home/python
WORKDIR /app

# Vibe is the process that "is" the container
ENTRYPOINT ["vibe"]
