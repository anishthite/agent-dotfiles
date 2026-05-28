#!/usr/bin/env bash
# ============================================================================
# sync.sh — Pull canonical agent config from $HOME into this repo.
#
# Mirrors:   ~/.agents/  ~/.claude/  ~/.codex/  ~/.gemini/  ~/.pi/
# Honors:    .gitignore (rsync --filter)
# Symlinks:  preserved as-is (relative targets survive cross-machine; absolute
#            targets do not — see TODO in implementation-notes for fix).
#
# Usage:
#   ./sync.sh              # actual sync (rsync, idempotent)
#   ./sync.sh --dry-run    # preview only
# ============================================================================

set -euo pipefail

REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$REPO_DIR"

SOURCES=(
  ".agents"
  ".claude"
  ".codex"
  ".gemini"
  ".pi"
)

RSYNC_OPTS=(
  -a
  --delete
  --no-perms
  --exclude-from="$REPO_DIR/.rsync-excludes"
)

if [ "${1:-}" = "--dry-run" ]; then
  RSYNC_OPTS+=(--dry-run --itemize-changes)
  echo "DRY RUN — no files written."
  echo ""
fi

for src in "${SOURCES[@]}"; do
  if [ -d "$HOME/$src" ]; then
    mkdir -p "$REPO_DIR/$src"
    echo "→ $HOME/$src/  →  $REPO_DIR/$src/"
    rsync "${RSYNC_OPTS[@]}" "$HOME/$src/" "$REPO_DIR/$src/"
  else
    echo "  skip $HOME/$src (not present)"
  fi
done

echo ""
echo "Sync complete. Review: git -C \"$REPO_DIR\" status"
