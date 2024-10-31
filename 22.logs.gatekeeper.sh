#!/usr/bin/env bash
set -xefu
# logs for both gatekeeper-controller and gatekeeper-audit
kubectl logs -n gatekeeper-system  --selector=gatekeeper.sh/system="yes"  --since=0m  --prefix --timestamps --follow \
| hl -R 'err'
# --tail=-1