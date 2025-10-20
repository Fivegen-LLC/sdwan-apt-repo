#!/usr/bin/env bash
set -euo pipefail

# Args:
#   $1 - codename (e.g., jammy)
#   $2 - components (e.g., main)
#   $3 - architectures (e.g., "amd64 arm64")

CODENAME="${1:-}"
COMPONENTS="${2:-}"
ARCHITECTURES="${3:-}"

if [[ -z "$CODENAME" || -z "$COMPONENTS" || -z "$ARCHITECTURES" ]]; then
  echo "Usage: $0 <codename> <components> <architectures>" >&2
  exit 1
fi

# Work directly in the repository root instead of creating apt-repo subdirectory
echo "Preparing repository structure in current directory"

# Ensure basic structure exists
mkdir -p conf
mkdir -p "dists/${CODENAME}/${COMPONENTS}/binary-amd64"
mkdir -p "dists/${CODENAME}/${COMPONENTS}/binary-arm64"
mkdir -p pool/main

# Create reprepro config if it doesn't exist
if [[ ! -s conf/distributions ]]; then
  echo "Creating reprepro configuration"
  cat > conf/distributions <<EOF
Codename: ${CODENAME}
Suite: ${CODENAME}
Architectures: ${ARCHITECTURES}
Components: ${COMPONENTS}
Description: SD-WAN APT Repository
Origin: sdwan-apt-repo
Label: sdwan-apt-repo
SignWith: default
EOF
else
  echo "Using existing reprepro configuration"
fi

echo "Repository structure prepared in current directory"

