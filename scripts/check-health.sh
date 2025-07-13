#!/usr/bin/env bash
set -euo pipefail

echo "=== Kubernetes Health Checker by Mahesh Phalle ==="
echo "Start time: $(date '+%Y-%m-%d %H:%M:%S')"

# Configurable timeouts
NODE_TIMEOUT="${NODE_TIMEOUT:-60s}"

# 1. Wait for all nodes to be Ready
echo "Waiting up to $NODE_TIMEOUT for all nodes Ready..."
kubectl wait --for=condition=Ready nodes --all --timeout="$NODE_TIMEOUT"
echo "✅ All nodes are Ready."

# 2. Detect and restart pods with crashes
echo "Checking for pod restarts..."
mapfile -t cr_pods < <(
  kubectl get pods --all-namespaces \
    --field-selector=status.phase=Running \
    -o jsonpath='{range .items[*]}{.metadata.namespace}/{.metadata.name}{"\t"}{.status.containerStatuses[0].restartCount}{"\n"}{end}' \
  | awk '$2 > 0 {print $1}'
)

if [[ ${#cr_pods[@]} -gt 0 ]]; then
  echo "⚠️ Restarting crashed pods:"
  for p in "${cr_pods[@]}"; do
    echo "  • $p"
    ns="${p%%/*}"
    name="${p##*/}"
    kubectl delete pod -n "$ns" "$name"
  done
else
  echo "✅ No crashed pods found."
fi
