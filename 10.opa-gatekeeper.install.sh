#!/usr/bin/env bash
set -xefu

kubectl config set-context kind-kind

# install OPA+Gatekeeper
kubectl apply -f https://raw.githubusercontent.com/open-policy-agent/gatekeeper/v3.17.1/deploy/gatekeeper.yaml
