#!/usr/bin/env bash
set -euo pipefail

# Args:
#   $1 - source_repo (e.g., Fivegen-LLC/temp-packages-123456)
#   $2 - out_dir (e.g., packages)

SRC_REPO="${1:-}"
OUT_DIR="${2:-packages}"

if [[ -z "$SRC_REPO" ]]; then
  echo "Usage: $0 <source_repo> [out_dir]" >&2
  exit 1
fi

echo "Cloning repository: $SRC_REPO"
rm -rf /tmp/src || true
gh repo clone "$SRC_REPO" /tmp/src

echo "Copying packages to: $OUT_DIR"
mkdir -p "$OUT_DIR"
cp /tmp/src/packages/*.deb "$OUT_DIR" 2>/dev/null || {
  echo "No .deb files found in $SRC_REPO/packages/" >&2
  exit 1
}

echo "Packages copied successfully:"
ls -la "$OUT_DIR"

