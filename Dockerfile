# 1. BUILD STAGE
FROM python:3.12-slim-bookworm as builder

# Install everything needed to download/build (pinned versions)
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
      curl \
      unzip=6.0-28 \
    && rm -rf /var/lib/apt/lists/*

# Install Deno (check for latest stable version)
RUN curl -fsSL https://deno.land/x/install/install.sh -o /tmp/deno_install.sh && \
    /bin/sh /tmp/deno_install.sh && \
    rm /tmp/deno_install.sh

# Install mistral-vibe (get latest version)
RUN pip install --no-cache-dir mistral-vibe

# 2. RUNTIME STAGE
FROM python:3.12-slim-bookworm

# Minimal runtime dependencies only (pinned versions)
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
      elixir=1.14.0.dfsg-2 \
    && rm -rf /var/lib/apt/lists/* && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# Remove package managers and build tools from final image
RUN rm -rf /usr/bin/apt /usr/bin/apt-get /usr/bin/dpkg /var/lib/dpkg

# Copy Deno binary (v2.7.7 uses /root/.deno/bin/deno)
COPY --from=builder /root/.deno/bin/deno /usr/local/bin/deno

# Copy Python packages and the 'vibe' executable
COPY --from=builder /usr/local/lib/python3.12/site-packages /usr/local/lib/python3.12/site-packages
COPY --from=builder /usr/local/bin/vibe /usr/local/bin/vibe

# Create work dirs
RUN mkdir -p /home/python/.vibe /app
WORKDIR /app

# Copy agent instructions (will be overridden by volume mount if present)
COPY AGENTS.md /home/python/AGENTS.md

ENTRYPOINT ["vibe"]
