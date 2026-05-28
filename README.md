# agent-dotfiles

Versioned config for every coding agent I run — Claude Code, Codex CLI, pi,
Gemini CLI — with shared canonical skills and instructions in `.agents/`.

## Layout

```
.agents/               # single source of truth
├── AGENTS.md          # canonical user-level instructions
└── skills/            # canonical skills, symlinked from vendor dirs

.claude/               # Claude Code  (settings + symlinks)
.codex/                # Codex CLI    (config.toml + symlinks)
.gemini/               # Gemini CLI   (symlink to AGENTS.md)
.pi/                   # pi agent     (settings + extensions + symlinks)
```

## Usage

```bash
./sync.sh                  # $HOME → repo
./bootstrap.sh             # repo → $HOME (dry run)
./bootstrap.sh --apply     # repo → $HOME (write)
```

Both are tiny `rsync` wrappers gated by `.gitignore` — no templating.

## New machine

```bash
gh repo clone anishthite/agent-dotfiles
cd agent-dotfiles
./bootstrap.sh             # preview the diff
./bootstrap.sh --apply
```

Then manually:
- Re-install Claude plugins from `.claude/plugins/installed_plugins.json`
  (`/plugins install ...`)
- Re-install pi packages listed in `.pi/agent/settings.json:packages`

## Not tracked

See `.gitignore`. Notably excluded: sessions, chat logs, auth tokens,
SQLite DBs, telemetry, `.claude/settings.local.json`, and
`.codex/rules/default.rules` (contains historical API keys baked into
command strings — sanitize and rotate before opting back in).
