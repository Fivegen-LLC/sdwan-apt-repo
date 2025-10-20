#!/usr/bin/env bash
set -euo pipefail

# Args:
#   $1 - pages_url (e.g., https://fivegen-llc.github.io/sdwan-apt-repo/)
#   $2 - codename (e.g., jammy)
#   $3 - components (e.g., main)
#   $4 - architectures (e.g., "amd64 arm64")

PAGES_URL="${1:-}"
CODENAME="${2:-}"
COMPONENTS="${3:-}"
ARCHITECTURES="${4:-}"

if [[ -z "$PAGES_URL" || -z "$CODENAME" || -z "$COMPONENTS" || -z "$ARCHITECTURES" ]]; then
  echo "Usage: $0 <pages_url> <codename> <components> <architectures>" >&2
  exit 1
fi

rm -rf apt-repo || true
mkdir -p apt-repo

# Import current Pages content (best-effort)
wget -r -nH --cut-dirs=1 -np -R "index.html*" -P apt-repo "$PAGES_URL" || true

mkdir -p apt-repo/conf
mkdir -p "apt-repo/dists/${CODENAME}/${COMPONENTS}/binary-amd64"
mkdir -p "apt-repo/dists/${CODENAME}/${COMPONENTS}/binary-arm64"
mkdir -p apt-repo/pool/main

if [[ ! -s apt-repo/conf/distributions ]]; then
  cat > apt-repo/conf/distributions <<EOF
Codename: ${CODENAME}
Suite: ${CODENAME}
Architectures: ${ARCHITECTURES}
Components: ${COMPONENTS}
Description: SD-WAN APT Repository
SignWith: default
EOF
fi

echo "Repository workspace prepared at ./apt-repo"

