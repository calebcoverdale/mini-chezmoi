---
name: k3s-do1-gitops
description: Operate and debug a single-node k3s cluster on DigitalOcean using Flux GitOps (Kustomizations + HelmReleases). Includes safe reconcile patterns, ingress checks, and observability (Loki + Alloy) troubleshooting.
---

# k3s (DO1) GitOps Ops

Use this skill when the user asks about k3s status, Flux/GitOps, HelmRelease failures, ingress routing, or cluster debugging on the DO droplet.

## Safety Rules

- Prefer GitOps changes (Flux) over imperative `kubectl apply`.
- Don’t print or paste secrets/tokens/kubeconfigs into chat. If you must inspect a secret, describe *where* it is and *what key* to check without dumping values.
- If `kubectl` isn’t installed locally, run commands over SSH and use `sudo k3s kubectl ...`.
- Avoid destructive actions (deleting namespaces/PVs) unless explicitly approved.

## Known Conventions (This Workspace)

- Flux repo: `digitalocean01/` (GitHub: `calebcoverdale/digitalocean01`)
- Apps root kustomization path (typical): `digitalocean01/do1-k3s/apps/_root`
- Single-node k3s uses default `local-path` storageclass.

## SSH-First Command Pattern

When running cluster commands from this workstation:

```bash
ssh root@<K3S_NODE_IP> 'sudo k3s kubectl get nodes -o wide'
```

Replace `<K3S_NODE_IP>` with the droplet’s public IP.

## Flux Reconcile (Without flux CLI)

If `flux` CLI is missing or broken, force a reconcile by annotating:

```bash
ssh root@<K3S_NODE_IP> '
  ts=$(date -Iseconds)
  sudo k3s kubectl -n flux-system annotate gitrepository flux-system fluxcd.io/reconcileAt="$ts" --overwrite
  sudo k3s kubectl -n flux-system annotate kustomization do1-apps fluxcd.io/reconcileAt="$ts" --overwrite
'
```

Verify applied revision:

```bash
ssh root@<K3S_NODE_IP> '
  sudo k3s kubectl -n flux-system get gitrepository flux-system -o jsonpath="{.status.artifact.revision}{\"\n\"}"
  sudo k3s kubectl -n flux-system get kustomization do1-apps -o jsonpath="{.status.lastAppliedRevision}{\"\n\"}"
'
```

## Triage Checklist

### Cluster health

```bash
ssh root@<K3S_NODE_IP> '
  sudo k3s kubectl get nodes -o wide
  sudo k3s kubectl get pods -A --field-selector=status.phase!=Running | sed -n "1,200p"
'
```

### Flux health

```bash
ssh root@<K3S_NODE_IP> '
  sudo k3s kubectl -n flux-system get gitrepositories,kustomizations,helmrepositories,helmreleases -o wide
'
```

### HelmRelease failure drilldown

```bash
ssh root@<K3S_NODE_IP> '
  sudo k3s kubectl -n <ns> describe helmrelease <name> | sed -n "1,240p"
'
```

### Events (why Pending/CrashLoop)

```bash
ssh root@<K3S_NODE_IP> '
  sudo k3s kubectl -n <ns> get events --sort-by=.lastTimestamp | tail -n 80
'
```

## Ingress / Routing

Figure out what ingress controller is running and what resources exist:

```bash
ssh root@<K3S_NODE_IP> '
  sudo k3s kubectl -n kube-system get pods | grep -i traefik || true
  sudo k3s kubectl get ingress -A
  sudo k3s kubectl get ingressroute -A 2>/dev/null || true
'
```

If the app is behind Pangolin (Cloudflare -> Traefik -> service), verify:
- service exists and endpoints are ready (`kubectl get svc,endpoints -n <ns>`)
- the service port matches container port
- the ingress rule host/path matches what Pangolin publishes

## Observability Defaults (Loki + Alloy)

When the user asks for logs:
- Use Grafana Alloy for collection (Promtail is deprecated).
- Loki should be reachable inside cluster at `http://loki.observability.svc.cluster.local:3100`.

Quick checks:

```bash
ssh root@<K3S_NODE_IP> '
  sudo k3s kubectl -n observability get pods,svc,pvc
  sudo k3s kubectl -n observability logs deploy/alloy --since=5m | tail -n 80
'
```

If a pod is Pending due to memory/CPU, check:

```bash
ssh root@<K3S_NODE_IP> '
  sudo k3s kubectl -n <ns> describe pod <pod> | sed -n "1,240p"
'
```

## Output Expectations

- Prefer repo edits under `digitalocean01/do1-k3s/...` then reconcile Flux.
- When presenting fixes, include:
  - exact file path(s) changed
  - the reconcile/verification commands to confirm applied state

