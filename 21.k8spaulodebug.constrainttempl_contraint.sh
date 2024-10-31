#!/usr/bin/env bash
set -xefu

# setup paulodebug
kubectl apply -f template_and_constraint/k8spaulodebug.constrainttemplate.yaml
kubectl apply -f template_and_constraint/k8spaulodebug.constraint.yaml