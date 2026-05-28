---
name: implementation-notes
description: Maintain a durable, append-only log of design decisions, deviations, tradeoffs, open questions, and blast-radius notes for any non-trivial implementation task. Use whenever you are implementing a feature, fixing a non-trivial bug, refactoring across files, doing a migration, or making any judgment call where the spec is ambiguous. Each task gets one HTML file in `implementation-notes/` at the workspace root. Specs are dense, tabular, signal-per-line — never prose dumps.
---

# Implementation Notes

Durable log of *why*, not *what*. The diff is the what.

## Activate when

Spec is ambiguous · deviating from spec/convention · weighing real alternatives · making an unverifiable assumption · touching migrations/env/public API/auth/deploy · deferring known work.

**Skip for:** one-line fixes, renames, lint, restating the spec.

## Layout

```
<notes-dir>/
  INDEX.html                       # roll-up of every task
  YYYY-MM-DD-<kebab-slug>.html     # one file per task
```

`<notes-dir>` defaults to `implementation-notes/` at workspace root. Overrides (cwd-based, deepest match wins):

| cwd matches | `<notes-dir>` |
|---|---|
| `~/workspace/bondu/**` | `docs/implementations/` |

Templates: `~/.agents/skills/implementation-notes/{template,index-template}.html`. Copy on first use.

## Density rules (non-negotiable)

A spec is signal-per-line. If a line doesn't change the reader's plan, cut it.

1. **Tables over prose** for any enumerable list (Files, Decisions, Tradeoffs, Followups). One row = one entry = one line. No `<details>/<summary>` collapses — they invite prose.
2. **One row, one sentence.** Patterns:
   - Decision: `<Choice>. <Reason>.`
   - Tradeoff: `<Picked> over <rejected>. <Reason>.`
   - Open Q: `<Topic>. Assumed: X. Alternatives: A, B.`
   - File: `<path> · new|touch|delete · <one-line delta>.`
3. **Concrete artifacts beat descriptions.** API request/response shapes as literal `<pre>` blocks. Algorithm as numbered steps with actual formulas, not paragraphs. Endpoint signatures, Zod field lists, file paths — show them.
4. **Summary is a key-value grid**, not narrative. ~8 rows max: Goal, Source, Surface, Schema, Mobile, Open Qs, plus task-specific.
5. **Drop empty sections.** No "Deviations: none" table with one empty row. Write `<em>None.</em>` or omit the heading.
6. **No context recaps.** Don't restate what the codebase already shows or the user already knows. Skip "Today, X exists at Y…" preambles.
7. **No labels inside entries.** Don't write `Context: … Chose: … Why: …`. The column header is the category.
8. **Imperative, present tense.** "Sort values; take nearest-rank." not "We will sort the values and then take the nearest-rank."
9. **`<code>` every path, identifier, formula, env var.** Scans faster than quoted English.
10. **Cut hedges.** "easy to widen later" / "minimum surprise" / "non-negotiable for trust" / "as a follow-up if needed" — gone. State the choice; trust the reader.

Rare prose-allowed sections: Algorithm (when non-trivial), Goal (≤2 sentences). Cap at 3 short sentences each.

## Required sections (in order)

| Section | When | Format |
|---|---|---|
| `<h1>` title | always | One line |
| `.meta` line | always | branch · worktree · date · status · blast |
| Summary | always | Key-value grid, ~8 rows |
| API contract | API change | Request + response as `<pre>` |
| Algorithm | non-trivial logic | Numbered `<ol>` |
| UI layout | UI change | Numbered `<ol>`, one component per item |
| Files | always | Table: Path · Kind · Delta |
| Decisions | ≥1 D-entry | Table: ID · Choice · Rationale |
| Deviations | ≥1 X-entry | Table or `<em>None.</em>` |
| Tradeoffs | ≥1 T-entry | Table: ID · Picked over Rejected · Reason |
| Open questions | ≥1 Q-entry | `.q` divs, one per question |
| Assumptions | ≥1 A-entry | `<ul>` |
| Reversibility | always | One paragraph per R-entry |
| Followups | ≥1 L-entry | `<ul>` |
| Definition of done | always | Checklist `<ul>` |

Drop any section with zero entries (except Summary, Files, Reversibility, DoD).

## Entry IDs (append-only, never reuse)

| ID | Kind |
|---|---|
| `D-*` | Decision — picked an interpretation |
| `X-*` | Deviation — departed from spec/convention |
| `T-*` | Tradeoff — alternatives weighed |
| `Q-*` | Open question — needs user input; record assumption |
| `A-*` | Assumption — taken as given; flag impact if wrong |
| `F-*` | File — only when *why* isn't obvious from the diff (most files stay in the Files table) |
| `R-*` | Reversibility — blast + revert path |
| `L-*` | Followup — deferred / out-of-scope |

Append-only. Never rewrite. Supersede with a new entry citing `Supersedes: D-004`. One atomic point per entry.

## Workflow

1. **Before starting:** `rg --type html "tags.*<keyword>" <notes-dir>` for prior work. Cite related logs in `<meta name="related">`.
2. **Create file:** copy `template.html` to `YYYY-MM-DD-<slug>.html`. Fill `<meta>`.
3. **Write the spec in one pass.** Summary → contract → algorithm → UI → files → decisions → tradeoffs → open Qs. Stay in tables; resist drift to prose.
4. **Update `INDEX.html`** — one row, newest first: date, title, status, blast, tags, ≤1-line summary.
5. **Resolve open questions** inline in chat (preferred), or `plannotator annotate <file>` if installed. For each: flip `Q-*` to `RESOLVED: <answer>`, apply implied code changes, ask whether to promote to `AGENTS.md`.
6. **Log as you implement.** Append new D/X/T/A/R/L entries when a judgment moment arrives. Re-sync the Summary grid.
7. **On completion:** set `<meta status>` to `ready-for-review` or `shipped`. Surface any `Q-* [OPEN]` at the top of your reply.

## Blast radius

| Level | Examples |
|---|---|
| **low** | Code-only, additive, easy revert |
| **medium** | Schema additions, env vars, public API, auth surfaces |
| **high** | Forward-only migrations, data backfills, third-party calls with side effects, prod deploys, secret rotations |

File's overall blast = max of its `R-*` entries. If any is `high`, name it in the Summary grid.

## Code & commit anchors

- Commit message: `Implements: notes/<file>#D-002`
- Inline comment: `// Decision: see notes/<file>#D-002`

Gives `git blame → commit → entry` from any line of code.

## Anti-patterns

- ❌ One rolling file. Always one per task.
- ❌ Restating the spec or the codebase. Log judgment, not activity.
- ❌ Rewriting old entries. Append + supersede.
- ❌ Summary drifting from detail.
- ❌ `<details>/<summary>` collapses — they invite prose. Use tables.
- ❌ Paragraphs where a row would do.
- ❌ `Context: … Chose: … Why: …` labels inside entries.
- ❌ Hedges, marketing, "we believe", "easy to extend later".
- ❌ Empty sections kept for symmetry.
- ❌ Inline `<script>` or `localStorage`. It's a static record.
