---
name: pangolin-docs-latest
description: Fetch and use the latest Pangolin documentation (via docs.pangolin.net/llms.txt) before making recommendations or changes, especially for Cloudflare proxy, wildcard DNS-01 certs, Kubernetes sites (Newt), and the Integration API.
---

# Pangolin Docs (Latest)

Use this skill when the user asks to “look up the latest docs”, wants doc-backed steps, or when Pangolin behavior/config could have changed since memory (Cloudflare proxy, wildcard certs, forwarded headers, Kubernetes Newt, API).

## Non-Negotiables

- Always start from the Pangolin docs index at `https://docs.pangolin.net/llms.txt` to discover the current page set.
- Prefer opening the HTML doc pages (e.g. `/self-host/advanced/cloudflare-proxy`) over raw `*.md` links when browsing.
- Never paste secrets/tokens/identity material into chat (API keys, OAuth secrets, WireGuard keys, kubeconfigs, etc.).

## Workflow

1. Fetch and scan the docs index:
   - Open `https://docs.pangolin.net/llms.txt`.
   - Identify the most relevant pages by keyword and section.

2. Open only the pages needed for the user’s question (avoid bulk-loading).
   - Common entrypoints:
     - Cloudflare proxy: `/self-host/advanced/cloudflare-proxy`
     - Wildcard domains (DNS-01): `/self-host/advanced/wild-card-domains`
     - Config file reference: `/self-host/advanced/config-file`
     - Integration API: `/manage/integration-api` and `/self-host/advanced/integration-api`
     - Kubernetes Newt site: `/manage/sites/install-kubernetes`
     - Forwarded headers: `/manage/access-control/forwarded-headers`

3. Extract the minimum “do this, then that” set of steps, and state them with concrete config keys and file locations.
   - If docs mention version gates (e.g., “Badger 1.3.0+”, “installer 1.14.0+”), call them out explicitly.

4. If the user wants changes applied on the VPS/cluster:
   - Switch to (or additionally use) the `pangolin` skill for repo paths, compose/k3s workflows, and safe operations.

## Quick Checks (When Troubleshooting)

- Cloudflare proxy enabled:
  - Confirm SSL/TLS mode is `Full (Strict)`.
  - Ensure Pangolin config sets `gerbil.base_endpoint` to the VPS public IP (Cloudflare hides origin IP).
  - Ensure Pangolin trusts proxy depth correctly (e.g. `server.trust_proxy` when Cloudflare + Traefik).
  - Ensure Cloudflare websockets are enabled if tunnels/clients rely on them.

- Wildcard certs (DNS-01):
  - Confirm Traefik DNS provider config and credentials are present and being used for `*.domain`.
  - Confirm port 80 expectations match docs (often not needed with wildcard certs).

## Output Expectations

- Provide a concise, doc-backed answer.
- Include concrete URLs you opened (via citations in the normal assistant response).
- If a step depends on the user’s environment (domain/provider/installer version), ask only for the missing variable(s).

