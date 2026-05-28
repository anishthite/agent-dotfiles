# agent-dotfiles

Versioned config for every coding agent I run — Claude Code, Codex CLI, pi,
Gemini CLI — plus the shared canonical skills and instructions they all
consume.

## Layout

```
.agents/
├── AGENTS.md          # canonical user-level agent instructions
└── skills/            # canonical skills, symlinked from every vendor dir
    ├── emil-design-eng/
    ├── implementation-notes/
    ├── screenshot/
    ├── define-goal/
    ├── playwright/
    ├── playwright-interactive/
    └── ...

.claude/               # Claude Code: settings + symlinks back to .agents/
.codex/                # Codex CLI:   config.toml + skills/ + symlinks
.gemini/               # Gemini CLI:  symlink to AGENTS.md
.pi/                   # pi agent:    settings + extensions + symlinks
```

## Usage

```bash
# Pull current $HOME state into this repo (run after any local changes)
./sync.sh

# Restore from repo back to $HOME (dry run by default)
./bootstrap.sh             # preview
./bootstrap.sh --apply     # actually write
```

## What's tracked

- Canonical skills (`.agents/skills/`)
- Per-vendor authored skills (`smart-goal`, `frontend-design`, etc.)
- Global `AGENTS.md` (canonical user instructions)
- Per-vendor settings: `.claude/settings.json`, `.codex/config.toml`,
  `.pi/agent/settings.json`
- Plugin manifest (`installed_plugins.json`)

## What's NOT tracked

See `.gitignore` for the full list. Highlights:

- Sessions, chat logs, project history (`*/sessions/`, `*/projects/`)
- Auth tokens, OAuth caches (`auth.json`, `mcp-oauth/`, `*-cache.json`)
- SQLite DBs, WAL files, telemetry, plugin marketplace checkouts
- **`.codex/rules/default.rules`** — Codex's command-allow history file
  contains historical API keys baked into command strings. Sanitize and
  rotate any leaked keys before opting back in.
- `.claude/settings.local.json` — machine-local overrides

## New machine bootstrap

```bash
cd ~/workspace
gh repo clone anishthite/agent-dotfiles      # or wherever you push it
cd agent-dotfiles
./bootstrap.sh             # dry run first — read the diff
./bootstrap.sh --apply     # apply
```

After `--apply`:
- Skill symlinks are recreated fresh pointing at `~/.agents/skills/<name>`
- `AGENTS.md` symlinks are recreated fresh pointing at the canonical
- Re-install plugins listed in `.claude/plugins/installed_plugins.json`
  manually (`/plugins install ...` inside Claude Code)
- Re-install pi packages listed in `.pi/agent/settings.json:packages`

## Design notes

- Single source of truth is `.agents/`. Everything else either symlinks
  in or holds vendor-specific config.
- `sync.sh` and `bootstrap.sh` are deliberately tiny `rsync` wrappers
  with a strict `.gitignore` filter — no templating, no DSL.
- See `implementation-notes/` for design decisions and open questions.
