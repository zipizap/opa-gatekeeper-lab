#!/usr/bin/env bash
set -xefu

# intent create pod to cause violation and warning message showing debug info
kubectl apply -f k8spaulodebug.pod.yaml --dry-run=server
