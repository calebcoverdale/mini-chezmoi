---
name: mcp-sqlcipher-autounlock
description: Use this skill when setting up or maintaining the environment-sync Codex MCP server for inventory DB syncing, secret upserts, and service-to-secret linkage with SSH forwarded-key unlock.
---

# MCP Secure-Sync Auto-Unlock

## Overview

Use this skill to configure and maintain the JS MCP server at `~/sqlcipher-ssh/mcp/server.js` and ensure it launches through `~/sqlcipher-ssh/mcp/run-mcp.sh`, which auto-attempts `unlock-db.sh` from the current SSH session.

## When To Use

- Creating or updating the Codex MCP entry for inventory/env sync.
- Verifying MCP startup behavior after secure unlock changes.
- Syncing service environment variables from `systemd` + `/etc/sysconfig/<service>` into `service_env_vars`.

## Core Workflow

For scalable service growth, use `references/service-onboarding.md` as the default pattern when adding any new app/provider.

1. Verify MCP registration:

```bash
codex mcp list --json
codex mcp get environment-sync --json
```

2. Register or re-register MCP server:

```bash
codex mcp remove environment-sync || true
codex mcp add environment-sync -- ~/sqlcipher-ssh/mcp/run-mcp.sh
```

3. Validate unlock-aware launcher:

```bash
~/sqlcipher-ssh/mcp/run-mcp.sh
```

Expected behavior:
- If SSH key forwarding unlock is available, launcher exports `SQLCIPHER_KEY`/`SQLCIPHER_KEY_FILE` first.
- MCP server then starts and can use unlocked context.

4. Use MCP tool `environment_sync` with:
- `serviceName` (required)
- optional `serviceType` (defaults to `serviceName`)
- optional `unitName` and `envFile`

5. Use MCP tool `upsert_secret` to store secret metadata/encrypted value records in `secrets`.

6. Use MCP tool `link_service_secret` to connect a service to a secret in `service_secrets` with a purpose like `tls_cert` or `tls_key`.

7. For NetBird CLI visibility, use read-only tools:
- `netbird_help`
- `netbird_status`
- `netbird_forwarding_list`
- `netbird_networks_list`
- `netbird_state_list`
- `netbird_service_status`

## References

- Runtime layout and tool behavior: `references/layout.md`
- Scalable onboarding for new services and secrets: `references/service-onboarding.md`

## Notes

- Current DB path is `~/sqlcipher-ssh/data/inventory.db` (provided via MCP env `INVENTORY_DB_PATH`).
- `environment_sync` updates `hosts`, `services`, and rewrites `service_env_vars` for the target service.
- `upsert_secret` writes `secrets`.
- `link_service_secret` writes `service_secrets`.
- Secret-like variable names (`KEY`, `TOKEN`, `SECRET`, `PASSWORD`, `PASS`, `PRIVATE`) are marked `is_secret=1`.
