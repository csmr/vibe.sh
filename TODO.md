## Security Architecture Notes

**Current Isolation Model:**
- Host directory (${JAIL_PATH}) → Container /app (read-write)
- Host .vibe_config → Container /home/python/.vibe (persistent config)
- Container runs as host user (${UA_UID}:${UA_GID}) with HOME=/home/python
- Docker socket mounting disabled by default (security)

**Threat Model:**
- Container has same permissions as host user within mounted directories
- Container cannot access other host files outside mounted volumes
- API keys in .vibe_config are accessible to container (treat as semi-trusted)

## Prioritized TODO List

### Implemented ✅
7. Supply-chain & image hygiene (COMPLETED)
   - ✅ Pinned unzip=6.0-28 and elixir=1.14.0.dfsg-2 versions
   - ✅ curl now uses latest available version (removed pinning to avoid dependency conflicts)
   - ✅ Removed package managers (apt, apt-get, dpkg) from final runtime image
   - ✅ Minimized image by cleaning apt caches and temp files
   - ✅ Used --no-install-recommends for all apt installations
   - ✅ Configured to use latest stable versions of Deno and mistral-vibe

### Implemented ✅
2. Environment variable sanitization (COMPLETED)
   - ✅ Added explicit environment variable whitelisting in contvibe.sh
   - ✅ Container now only receives HOME, USER, PATH, TERM (minimal set)
   - ✅ Blocks inheritance of host environment secrets
   - ⚠️ Users should still avoid sensitive vars in host environment

### Medium Priority ⚠️
3. User namespace considerations
   - Current: Container runs as host user for seamless file permissions
   - Alternative: Use fixed UID (e.g., 65532) but requires chown workarounds
   - Decision: Current approach acceptable for development use case
   - Document trade-offs in README security section

### Medium Priority ⚠️
1. Lock down mounted paths
   - Use dedicated directory for JAIL_PATH (e.g., ~/cont_jail/<project>)
   - Make path configurable via --jailpath flag
   - Mount only necessary directories with appropriate permissions

3. User namespace remapping
   - Run container with fixed unprivileged UID (e.g., 65532)
   - Avoid matching host user permissions
   - Add explicit USER directive in Dockerfile

### Low Priority (Optional) 📝
4. Capability reduction
   - Add capability drops in compose.yaml
   - Implement minimal seccomp profile
   - Consider read-only root filesystem where possible

5. Network control
   - Add --network flag for explicit network enabling
   - Default to network=none for maximum isolation
   - Provide proxy configuration options when needed

## Minimal concrete changes (diff-style, essential lines only)
- vibe.sh
  - Change default: export JAIL_PATH="${HOME}/vibe_jail/$(basename $(pwd))"
  - Enforce explicit --jailpath override.
  - Remove docker group check; instead warn if docker not available and offer rootless instruction.
  - Create host config dir: mkdir -p "${HOME}/.vibe_jail_config" && chmod 700 ...

- compose.yaml (essential additions)
  - volumes: keep only - "${JAIL_PATH}:/app:rw"
  - remove docker.sock lines
  - add:
    user: "65532:65532"
    cap_drop:
      - ALL
    security_opt:
      - no-new-privileges:true
    read_only: true
    tmpfs:
      - /tmp:exec,mode=1777
    working_dir: /app

- Dockerfile (runtime)
  - Add USER 65532
  - Ensure no package managers left installed in final image (apt-get purge && rm -rf /var/lib/apt/lists/*)
  - Pin versions and replace remote install curl | sh with staged download + checksum verification.

## Documentation changes (README essentials)
- Clear title: "Contvibe — minimal dev sandbox for Vibe agents"
- Single-paragraph threat model + explicit list of allowed behaviors.
- Flags: --jailpath, --network=none|on, --allow-docker (explicit opt-in)
- Short hardening note: "Not a full host-hardening solution — use for dev testing only."

## Prioritized rollout plan (timeboxed)
- Day 0 (2–4 hrs): implement rename + README updates + change default JAIL_PATH + move .vibe_config to ~/.vibe_jail_config.
- Day 1 (4–8 hrs): adjust compose and Dockerfile: set fixed UID, read-only root, cap_drop, no-new-privileges, tmpfs mounts; test basic Vibe run.
- Day 2 (4–8 hrs): implement network=none default and explicit flag; add instructions for rootless Docker/Podman fallback.
- Day 3 (4–8 hrs): supply-chain: pin packages and add checksum verification for Deno/pip install steps; reduce final image.
- Day 4 (2–4 hrs): write concise security README section, add quick-start that emphasizes minimal trust and opt-ins.
- Ongoing: add optional advanced mode (admin opt-in) that mounts docker.sock but warns prominently.

## Minimal philosophy checklist
- Each file change must be justified: remove unused tooling, remove remote-installs unless checksummed, avoid matching host UID, and do least privilege.
- Defaults must favor safety (network off, no docker socket).
- Make opt-in explicit for any risky feature.

If you want, I can produce the exact minimal patch snippets for vibe.sh, compose.yaml, and Dockerfile following these changes.
