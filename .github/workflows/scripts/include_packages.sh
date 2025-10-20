#!/usr/bin/env bash
set -euo pipefail

# Args:
#   $1 - codename (e.g., jammy)
#   $2 - packages_dir (e.g., packages)

CODENAME="${1:-}"
PACKAGES_DIR="${2:-}"

if [[ -z "$CODENAME" || -z "$PACKAGES_DIR" ]]; then
  echo "Usage: $0 <codename> <packages_dir>" >&2
  exit 1
fi

if [[ ! -d "$PACKAGES_DIR" ]]; then
  echo "Packages dir not found: $PACKAGES_DIR" >&2
  exit 1
fi

shopt -s nullglob
for f in "$PACKAGES_DIR"/*.deb; do
  echo "Including $(basename "$f")"
  reprepro -b apt-repo includedeb "$CODENAME" "$f"
done
shopt -u nullglob

reprepro -b apt-repo export "$CODENAME"

echo "Indexes exported for ${CODENAME}"

