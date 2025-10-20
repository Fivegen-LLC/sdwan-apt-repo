#!/usr/bin/env bash
set -euo pipefail

# Keep only the latest N versions per package for a given codename using reprepro.
# It removes older versions via removefilter and re-exports indexes.
#
# Usage:
#   prune_versions.sh <codename> <keep_count>

CODENAME="${1:-}"
KEEP_COUNT="${2:-3}"

if [[ -z "$CODENAME" || -z "$KEEP_COUNT" ]]; then
  echo "Usage: $0 <codename> <keep_count>" >&2
  exit 1
fi

# Gather (package, version) pairs from reprepro list
mapfile -t entries < <(reprepro list "$CODENAME" | awk -F'|' '{gsub(/^[ \t]+|[ \t]+$/, "", $2); gsub(/^[ \t]+|[ \t]+$/, "", $3); if($2 && $3){print $2"|"$3}}' | sort -u)

if [[ ${#entries[@]} -eq 0 ]]; then
  echo "No packages found to prune for $CODENAME"
  exit 0
fi

# Build packages -> versions mapping
declare -A pkg_to_versions
for e in "${entries[@]}"; do
  pkg="${e%%|*}"
  ver="${e#*|}"
  pkg_to_versions["$pkg"]+="${ver}
"
done

# For each package, keep top N versions (sort -V desc), remove older via removefilter
removed_any=false
for pkg in "${!pkg_to_versions[@]}"; do
  # Unique and sort
  mapfile -t versions < <(printf "%s" "${pkg_to_versions[$pkg]}" | sed '/^$/d' | sort -Vr)
  if (( ${#versions[@]} <= KEEP_COUNT )); then
    continue
  fi
  for (( i=KEEP_COUNT; i<${#versions[@]}; i++ )); do
    oldver="${versions[$i]}"
    echo "Pruning ${pkg} version ${oldver}"
    # Remove only this version for this codename
    reprepro removefilter "$CODENAME" "(Package (== ${pkg})) & (Version (== ${oldver}))" || true
    removed_any=true
  done
done

if [[ "$removed_any" == "true" ]]; then
  echo "Re-exporting indexes after prune"
  reprepro export "$CODENAME"
else
  echo "Nothing to prune"
fi

echo "Prune completed"


