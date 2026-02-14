# Runtime Layout

- MCP server: `~/sqlcipher-ssh/mcp/server.js`
- MCP launcher: `~/sqlcipher-ssh/mcp/run-mcp.sh`
- Inventory DB: `~/sqlcipher-ssh/data/inventory.db`
- SQL migrations: `~/sqlcipher-ssh/db/migrations/*.sql`
- SSH unlock helpers: `~/sqlcipher-ssh/bin/unlock-db.sh`, `~/sqlcipher-ssh/bin/lock-db.sh`

# Main MCP Tool

`environment_sync`:
- Reads env vars from `systemctl show <unit> -p Environment --value`
- Reads env vars from `/etc/sysconfig/<service>` (or provided override)
- Upserts service row and replaces `service_env_vars` for that service
- Reports if secure unlock env was detected (`SQLCIPHER_KEY` or `SQLCIPHER_KEY_FILE`)

`upsert_secret`:
- Creates/updates a `secrets` row by unique `name`
- Supports secret types like `tls_cert`, `tls_key`, `api_key`

`link_service_secret`:
- Resolves service by `hostName + serviceName`
- Creates/updates `service_secrets` linkage with purpose such as `tls_cert` or `tls_key`

NetBird read-only tools:
- `netbird_help`
- `netbird_status`
- `netbird_forwarding_list`
- `netbird_networks_list`
- `netbird_state_list`
- `netbird_service_status`
