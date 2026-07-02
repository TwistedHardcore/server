#!/usr/bin/env bash
set -euo pipefail

REPO_DIR="$(cd "$(dirname "$0")/.." && pwd)"
SERVER_DIR="$REPO_DIR/server"
MC_VERSION="26.2"
mkdir -p "$SERVER_DIR"
cd "$SERVER_DIR"

echo "Fetching latest stable Fabric loader for MC $MC_VERSION..."
LOADER_VERSION=$(curl -s "https://meta.fabricmc.net/v2/versions/loader/${MC_VERSION}" | python3 -c "
import json, sys
data = json.load(sys.stdin)
stable = [d['loader']['version'] for d in data if d['loader'].get('stable')]
print(stable[0] if stable else data[0]['loader']['version'])
")
echo "Using Fabric Loader $LOADER_VERSION"

INSTALLER_VERSION=$(curl -s "https://meta.fabricmc.net/v2/versions/installer" | python3 -c "
import json, sys
print(json.load(sys.stdin)[0]['version'])
")

curl -sSL -o fabric-installer.jar \
  "https://maven.fabricmc.net/net/fabricmc/fabric-installer/${INSTALLER_VERSION}/fabric-installer-${INSTALLER_VERSION}.jar"

java -jar fabric-installer.jar server -mcversion "$MC_VERSION" -loader "$LOADER_VERSION" -downloadMinecraft

if [ -f "fabric-server-launch.jar" ]; then
  echo "Server jar ready: fabric-server-launch.jar"
else
  ls -la
  echo "WARNING: expected fabric-server-launch.jar not found — check the listing above"
fi

echo "eula=true" > eula.txt