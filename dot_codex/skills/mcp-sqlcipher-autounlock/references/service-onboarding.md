# Service Onboarding Pattern

Use this pattern whenever adding a new service to the `environment-sync` inventory.

## Naming Conventions

- `serviceName`: stable runtime identifier (examples: `netbird`, `n8n`, `windmill`, `cloudflared`)
- `serviceType`: category label used for grouping/reporting (examples: `vpn-overlay`, `automation`, `edge-tunnel`)
- `unitName`: exact systemd unit when different from default `<serviceName>.service`
- Secret names: uppercase snake case by provider/service, e.g. `DIGITAL_OCEAN_ACCESS_TOKEN`, `CLOUDFLARE_API_TOKEN`, `NETBIRD_SETUP_KEY`, `GITHUB_PAT`

## Standard Onboarding Workflow

1. Upsert service + env vars:
- Call `environment_sync`.
- Always set `serviceName`.
- Set `serviceType` for long-term organization.
- Set `unitName` only when non-default.

2. Store secrets:
- Call `upsert_secret` for each credential.
- Use `secretType` values like `api_key`, `token`, `tls_cert`, `tls_key`, `private_key`.
- Keep metadata in `metadataJson` for issuer, rotation owner, or expiry.

3. Link secrets to service:
- Call `link_service_secret` once per use-case (`purpose`), e.g. `api_token`, `tls_cert`, `tls_key`, `jwt_signing`.

4. Verify:
- Confirm service row exists.
- Confirm env rows refreshed in `service_env_vars`.
- Confirm `service_secrets` links are present for required purposes.

## Idempotency Rules

- `environment_sync` is safe to run repeatedly; it refreshes env vars for a service.
- `upsert_secret` is safe to run repeatedly by stable `name`.
- `link_service_secret` is safe to run repeatedly by `service + purpose`.
- Prefer rerunning with corrected inputs instead of manual DB surgery.

## Change and Decommission Pattern

- Rename service carefully: create new service record, relink secrets, then disable old service.
- Rotate secrets by updating existing secret name when continuity is needed.
- For one-off migrations, create a new secret name and relink purposes explicitly.

## Example Calls

### Systemd service with API token

`environment_sync` payload:

```json
{
  "serviceName": "n8n",
  "serviceType": "automation",
  "unitName": "n8n.service",
  "envFile": "/etc/sysconfig/n8n"
}
```

`upsert_secret` payload:

```json
{
  "name": "N8N_ENCRYPTION_KEY",
  "secretType": "token",
  "notes": "Primary n8n encryption key"
}
```

`link_service_secret` payload:

```json
{
  "serviceName": "n8n",
  "secretName": "N8N_ENCRYPTION_KEY",
  "purpose": "app_encryption"
}
```

### External provider credentials (no local container)

Use a provider-style service row so secrets still map cleanly:

```json
{
  "serviceName": "digitalocean",
  "serviceType": "cloud-provider"
}
```

Then store and link:

- `DIGITAL_OCEAN_ACCESS_TOKEN` -> purpose `api_token`
- `CLOUDFLARE_API_TOKEN` -> purpose `api_token`
- `GITHUB_PAT` -> purpose `api_token`

### TLS mapping for reverse proxy

- Store cert/key as separate secret rows (`tls_cert`, `tls_key`).
- Link with purposes `tls_cert` and `tls_key` to the target service.
