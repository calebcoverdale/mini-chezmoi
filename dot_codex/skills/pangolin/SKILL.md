---
name: pangolin
description: Operate Pangolin CE on this VPS (compose, gerbil/traefik), manage tunnels (clients + sites/newt), and provide VPN-only DNS using Blocky (no WAN DNS). Includes quick troubleshooting and safe DB cleanup patterns.
---

# Pangolin (VPS Ops)

This skill assumes the current workspace layout and conventions used on `digitalocean01`.

## Canonical Paths (This Repo)

- Pangolin stack: `digitalocean01/stacks/pangolin`
- Pangolin config: `digitalocean01/stacks/pangolin/config/config.yml`
- Traefik dynamic routes: `digitalocean01/stacks/pangolin/config/traefik/dynamic_config.yml`
- Pangolin SQLite DB: `digitalocean01/stacks/pangolin/config/db/db.sqlite`
- Pangolin-client DNS (Blocky-in-Gerbil netns): `digitalocean01/stacks/pangolin/config/dns/blocky.yml`

## Non-Negotiables (Safety)

- Never publish DNS to WAN (`:53`). DNS must be reachable only via the Pangolin tunnel or LAN.
- WAN exposure should be limited to: `22/tcp`, `80/tcp`, `443/tcp`, and Pangolin UDP tunnel ports (currently `51821/udp`, `21820/udp`).
- Avoid overlapping VPN address spaces. If removing NetBird later, pick a Pangolin subnet that does not overlap any remaining VPN routes.

## Common Commands

### Stack lifecycle

```bash
cd /home/calebcoverdale/digitalocean01/stacks/pangolin
sudo docker compose ps
sudo docker compose up -d
sudo docker compose down
```

### Health checks

```bash
# Dashboard/API
curl -fsS https://pangolin.homedevenv.com/api/v1/ | head

# Container health
sudo docker ps --format '{{.Names}}|{{.Status}}|{{.Ports}}' | grep -E 'pangolin|gerbil|traefik'
```

### Gerbil tunnel interface

```bash
sudo docker exec gerbil ip -4 addr show
sudo docker exec gerbil ss -luntp
```

## VPN-Only DNS (Recommended Pattern)

Goal: Pangolin clients (iPhone/macbook) use a DNS resolver that is only reachable when connected to Pangolin.

Implementation used here:
- Run Blocky in `network_mode: service:gerbil` so it listens on the Gerbil WireGuard interface.
- Keep WAN firewall strict; do not bind/publish `:53` on `eth0`.

Files:
- Compose adds `pangolin-blocky` service: `digitalocean01/stacks/pangolin/docker-compose.yml`
- Blocky config: `digitalocean01/stacks/pangolin/config/dns/blocky.yml`

### Troubleshooting iOS “DNS server mismatch”

Pangolin stores org subnets in DB (`orgs.subnet`, `orgs.utilitySubnet`). iOS may show:
- `dns_servers`: an IP inside `utilitySubnet`
- included routes that only cover that `utilitySubnet`

If Blocky is listening on a different subnet/IP than iOS is routing, DNS will not work.

Workflow:
1. Inspect what the client is routed to (from the iOS app, or from DB `orgs.utilitySubnet`).
2. Inspect where Blocky is listening:
   - `sudo docker exec gerbil ss -luntp | grep ':53'`
   - `sudo docker exec gerbil ip -4 addr show`
3. Fix by choosing ONE:
   - Update the client profile DNS server to match Blocky’s reachable tunnel IP.
   - Or move Blocky to the subnet the client is actually routing (preferred long-term; requires aligning with Pangolin’s utility subnet model).

## DB Ops (When You Must)

Prefer UI/API. Touch SQLite only for cleanup of obviously incorrect records (typos, duplicates), and keep it minimal.

### Read-only inspection

```bash
sqlite3 digitalocean01/stacks/pangolin/config/db/db.sqlite '.tables'
sqlite3 digitalocean01/stacks/pangolin/config/db/db.sqlite 'select siteId,name,orgId,subnet,online from sites order by siteId;'
sqlite3 digitalocean01/stacks/pangolin/config/db/db.sqlite 'select clientId,name,subnet,type,online from clients order by clientId;'
sqlite3 digitalocean01/stacks/pangolin/config/db/db.sqlite 'select orgId,name,subnet,utilitySubnet from orgs;'
```

### Safe deletion (example: accidental site typo)

Use FK cascades; delete the single row from `sites` and let the DB cascade.

```bash
sudo sqlite3 digitalocean01/stacks/pangolin/config/db/db.sqlite 'PRAGMA foreign_keys=ON; begin; delete from sites where siteId=<ID>; commit;'
```

Then verify no orphans:

```bash
sudo sqlite3 digitalocean01/stacks/pangolin/config/db/db.sqlite '
  select "sites",count(*) from sites
  union all select "siteResources",count(*) from siteResources
  union all select "targets",count(*) from targets
  union all select "newt",count(*) from newt;
'
```

