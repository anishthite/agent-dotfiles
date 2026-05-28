#!/usr/bin/env bash
# ============================================================================
# bootstrap.sh — Restore agent config from this repo to $HOME.
#
# Default is dry-run. Pass --apply to actually write.
#
# Strategy:
#   1. rsync repo/.{agents,claude,codex,gemini,pi}/  →  $HOME/.{...}/
#      (preserves symlinks; --filter follows .gitignore)
#   2. Recreate the per-vendor skill symlink fanout from ~/.agents/skills/*
#      (fixes any stale absolute-path symlinks from another machine)
#   3. Recreate AGENTS.md symlink fanout
#      (canonical: ~/.agents/AGENTS.md if present, else ~/.pi/agent/AGENTS.md)
#
# Safe to run multiple times.
# ============================================================================

set -euo pipefail

REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

APPLY=0
case "${1:-}" in
  --apply) APPLY=1 ;;
  --dry-run|"") APPLY=0 ;;
  *) echo "Usage: $0 [--dry-run|--apply]"; exit 2 ;;
esac

SOURCES=(
  ".agents"
  ".claude"
  ".codex"
  ".gemini"
  ".pi"
)

RSYNC_OPTS=(
  -a
  --no-perms
  --exclude-from="$REPO_DIR/.rsync-excludes"
)
if [ "$APPLY" -eq 0 ]; then
  RSYNC_OPTS+=(--dry-run --itemize-changes)
  echo "DRY RUN — pass --apply to actually restore."
  echo ""
fi

# --- Step 1: rsync repo content into $HOME ---
for src in "${SOURCES[@]}"; do
  if [ -d "$REPO_DIR/$src" ]; then
    mkdir -p "$HOME/$src"
    echo "→ $REPO_DIR/$src/  →  $HOME/$src/"
    rsync "${RSYNC_OPTS[@]}" "$REPO_DIR/$src/" "$HOME/$src/"
  fi
done

if [ "$APPLY" -eq 0 ]; then
  echo ""
  echo "(dry run complete — re-run with --apply to write)"
  exit 0
fi

# --- Step 2: recreate skill symlink fanout ---
echo ""
echo "→ recreating skill symlinks from ~/.agents/skills/"
if [ -d "$HOME/.agents/skills" ]; then
  for skill_path in "$HOME"/.agents/skills/*/; do
    [ -d "$skill_path" ] || continue
    name=$(basename "$skill_path")
    for vendor_dir in "$HOME/.claude/skills" "$HOME/.pi/agent/skills"; do
      mkdir -p "$vendor_dir"
      target="$vendor_dir/$name"
      if [ -e "$target" ] && [ ! -L "$target" ]; then
        echo "    skip (real dir, not symlink): $target"
        continue
      fi
      rm -f "$target"
      relpath=$(python3 -c "import os, sys; print(os.path.relpath(sys.argv[1], sys.argv[2]))" \
                  "$HOME/.agents/skills/$name" "$vendor_dir")
      ln -s "$relpath" "$target"
      echo "    ✓ $target → $relpath"
    done
  done
fi

# --- Step 3: recreate AGENTS.md symlink fanout ---
echo ""
echo "→ recreating AGENTS.md symlinks"
CANONICAL=""
if [ -f "$HOME/.agents/AGENTS.md" ] && [ ! -L "$HOME/.agents/AGENTS.md" ]; then
  CANONICAL="$HOME/.agents/AGENTS.md"
elif [ -f "$HOME/.pi/agent/AGENTS.md" ] && [ ! -L "$HOME/.pi/agent/AGENTS.md" ]; then
  CANONICAL="$HOME/.pi/agent/AGENTS.md"
fi

if [ -n "$CANONICAL" ]; then
  echo "    canonical: $CANONICAL"
  for link in "$HOME/.claude/CLAUDE.md" \
              "$HOME/.codex/AGENTS.md" \
              "$HOME/.gemini/GEMINI.md" \
              "$HOME/.pi/agent/AGENTS.md" \
              "$HOME/.agents/AGENTS.md"; do
    [ "$link" = "$CANONICAL" ] && continue
    mkdir -p "$(dirname "$link")"
    ln -snf "$CANONICAL" "$link"
    echo "    ✓ $link"
  done
else
  echo "    skip — no AGENTS.md found"
fi

echo ""
echo "Done. Verify: ls -la ~/.claude/skills/ ~/.pi/agent/skills/"
