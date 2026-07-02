#!/usr/bin/env bash
set -uo pipefail
REPO_DIR="$(cd "$(dirname "$0")/.." && pwd)"
cd "$REPO_DIR"
while true; do
  sleep 600
  if [ -n "$(git status --porcelain)" ]; then
    git add -A
    git commit -m "autopush $(date -u +%FT%TZ)"
    git push origin main || echo "autopush: push failed, retrying next cycle"
  fi
done