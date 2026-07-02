#!/usr/bin/env bash
  set -euo pipefail
 
  echo "=== One-time setup starting ==="
 
  # --- Java 25 via SDKMAN (too new for apt/devcontainer features) ---
set +u   # SDKMAN's installer breaks under nounset; SHELLOPTS leaks -u
         # into it even through curl | bash
if [ ! -d "$HOME/.sdkman" ]; then
  curl -s "https://get.sdkman.io" | bash
fi
source "$HOME/.sdkman/bin/sdkman-init.sh"
set -u
 
  # --- tools the rest of the system needs ---
  sudo apt-get update -y
  sudo apt-get install -y python3 tmux jq
 
  # --- playit.gg (official apt repo, matches the daemon path we rely on) ---
  curl -SsL https://playit-cloud.github.io/ppa/key.gpg | sudo tee /etc/apt/trusted.gpg.d/playit.asc
  sudo curl -SsL -o /etc/apt/sources.list.d/playit-cloud.list https://playit-cloud.github.io/ppa/playit-cloud.list
  sudo apt-get update -y
  sudo apt-get install -y playit
 
  # --- Fabric server ---
  bash "$(dirname "$0")/../scripts/install-fabric.sh"
 
  echo "=== One-time setup complete ==="