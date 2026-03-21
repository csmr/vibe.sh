# 1. BUILD STAGE
FROM python:3.12-slim-bookworm as builder

# Install everything needed to download/build
RUN apt-get update && apt-get install -y curl unzip && rm -rf /var/lib/apt/lists/*

# Install Deno & Vibe
RUN curl -fsSL https://deno.land/install.sh | sh -s v2.7.7
RUN pip install --no-cache-dir mistral-vibe

# 2. RUNTIME STAGE
FROM python:3.12-slim-bookworm

# Only install what is strictly necessary to RUN the app
RUN apt-get update && \
    apt-get install -y --no-install-recommends elixir && \
    rm -rf /var/lib/apt/lists/*

# Copy Deno binary (v2.7.7 uses /root/.deno/bin/deno)
COPY --from=builder /root/.deno/bin/deno /usr/local/bin/deno

# Copy Python packages and the 'vibe' executable
COPY --from=builder /usr/local/lib/python3.12/site-packages /usr/local/lib/python3.12/site-packages
COPY --from=builder /usr/local/bin/vibe /usr/local/bin/vibe

# Create work dirs
RUN mkdir -p /home/python/.vibe /app
WORKDIR /app

ENTRYPOINT ["vibe"]
