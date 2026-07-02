#!/usr/bin/env bash
set -uo pipefail
REPO_DIR="$(cd "$(dirname "$0")/.." && pwd)"
IDLE_LIMIT_MIN=15
CHECK_INTERVAL=60
idle_count=0

while true; do
  sleep "$CHECK_INTERVAL"
  tmux has-session -t mc 2>/dev/null || exit 0

  tmux send-keys -t mc "list" Enter
  sleep 2
  players=$(tmux capture-pane -t mc -p | tail -5 | grep -oE "There are [0-9]+" | grep -oE "[0-9]+" | tail -1)
  players=${players:-0}

  if [ "$players" -eq 0 ]; then
    idle_count=$((idle_count + 1))
  else
    idle_count=0
  fi

  if [ "$idle_count" -ge "$((IDLE_LIMIT_MIN * 60 / CHECK_INTERVAL))" ]; then
    echo "[$(date -u)] idle ${IDLE_LIMIT_MIN}m, stopping"
    bash "$REPO_DIR/scripts/stop.sh"
    exit 0
  fi
done