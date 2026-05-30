---
name: code-review
description: Automated multi-agent code review for a GitHub pull request with confidence-based scoring to filter false positives. Use when the user asks to "review this PR", "code review", "audit this pull request", "check this PR against CLAUDE.md", or "post a review comment on PR #N". Requires `gh` CLI authenticated. Skips closed/draft/trivial/already-reviewed PRs automatically.
---

# Code Review

> Adapted from Anthropic's [`code-review`](https://github.com/anthropics/claude-plugins-official/tree/main/plugins/code-review) plugin command.

Automated code review for a pull request using multiple specialized agents that run in parallel and independently audit the changes. Each finding is scored 0–100 for confidence; only findings ≥ 80 are surfaced. The default output is a single GitHub PR comment.

## When to Use This Skill

- User asks to review a pull request, audit a diff, or check PR compliance against `CLAUDE.md` / `AGENTS.md`
- User wants a "second pair of eyes" pass on a sizable PR before merge
- User wants to post an automated review comment

Do **not** use this skill for:
- Closed or draft PRs (skip explicitly anyway)
- Trivial/automated PRs (e.g. dependabot bumps)
- PRs the user has already reviewed

## Workflow

Follow these steps precisely:

1. **Eligibility check (Haiku-class agent).** Determine whether the PR is (a) closed, (b) a draft, (c) trivial / does not need a review, or (d) already has a review from you. If any of these, stop.

2. **Gather guideline file paths (Haiku-class agent).** Return the *paths only* (not contents) of the root `CLAUDE.md` / `AGENTS.md` and any equivalent files in directories the PR modifies.

3. **Summarize the change (Haiku-class agent).** View the PR (`gh pr view`, `gh pr diff`) and return a short summary.

4. **Launch parallel reviewers (Sonnet-class agents).** Run these in parallel; each returns a list of issues with the reason flagged (e.g. `CLAUDE.md` adherence, bug, historical context):
   - **Agent #1 — CLAUDE.md compliance.** Audit changes against `CLAUDE.md`. Note that `CLAUDE.md` is guidance for *writing* code; not all instructions apply during review.
   - **Agent #2 — Shallow bug scan.** Read only the diff. Look for obvious, high-impact bugs. Skip nitpicks and likely false positives.
   - **Agent #3 — Historical context (`git blame`).** Identify bugs in light of the file's history.
   - **Agent #4 — Prior-PR comments.** Read previous PRs touching these files and surface comments that still apply.
   - **Agent #5 — Inline comments.** Read code comments in modified files and check the diff complies with any guidance there.

5. **Confidence scoring (parallel Haiku-class agent per issue).** Each issue gets a 0–100 score using this rubric (give the rubric to the agent verbatim):
   - **0**  — Not confident at all. False positive under light scrutiny, or pre-existing.
   - **25** — Somewhat confident. Might be real, might be a false positive. Unverifiable. For stylistic issues: not explicitly in `CLAUDE.md`.
   - **50** — Moderately confident. Verified as real, but a nitpick or rare. Not very important relative to the rest of the PR.
   - **75** — Highly confident. Double-checked and very likely to hit in practice. Existing approach is insufficient. Directly impacts functionality, or directly called out in `CLAUDE.md`.
   - **100** — Absolutely certain. Confirmed real, frequent in practice. Evidence is direct.

6. **Filter.** Drop any issue scoring < **80**. If none remain, stop — do not post.

7. **Re-check eligibility (Haiku-class agent).** Repeat step 1 to confirm the PR is still review-eligible (state may have changed during the run).

8. **Post the comment** with `gh pr comment`. Keep output brief, no emojis, link and cite each finding with a permalink including the **full** SHA.

## False Positives to Filter

- Pre-existing issues not introduced in this PR
- Things that look like bugs but aren't
- Pedantic nitpicks a senior engineer wouldn't raise
- Anything a linter / typechecker / compiler / formatter will catch (imports, type errors, formatting, broken tests). Assume CI runs separately.
- General quality concerns (test coverage, security, docs) unless explicitly required by `CLAUDE.md`
- `CLAUDE.md` violations that are explicitly silenced in code (e.g. lint-ignore comments)
- Functionality changes that are intentional or directly related to the PR's scope
- Real issues on lines the user did not modify

## Output Format

When you find issues, post exactly this shape:

```markdown
### Code review

Found N issues:

1. <brief description> (CLAUDE.md says "<exact quote>")

<https://github.com/owner/repo/blob/<FULL-SHA>/path/to/file.ext#L<start>-L<end>>

2. <brief description> (some/other/CLAUDE.md says "<exact quote>")

<link with full SHA and line range>

3. <brief description> (bug due to <file and code snippet>)

<link with full SHA and line range>

🤖 Generated with [Claude Code](https://claude.ai/code)

<sub>- If this code review was useful, please react with 👍. Otherwise, react with 👎.</sub>
```

When you find none:

```markdown
### Code review

No issues found. Checked for bugs and CLAUDE.md compliance.

🤖 Generated with [Claude Code](https://claude.ai/code)
```

## Linking Rules (Strict)

Permalinks **must** follow this exact shape or GitHub's Markdown preview breaks:

```
https://github.com/<owner>/<repo>/blob/<FULL-SHA>/<path>#L<start>-L<end>
```

- Full git SHA, not abbreviated. **No** `$(git rev-parse HEAD)` interpolation — the comment is rendered as Markdown, not executed.
- `#L` notation, `L<start>-L<end>` range.
- At least one line of context before and after the cited line(s) (e.g. for lines 5–6, link `L4-L7`).
- Repo name must match the PR's repo.

## Notes

- Do **not** run build / typecheck / tests — CI handles that.
- Use `gh` for all GitHub interaction (PRs, diffs, blame, comments). Avoid web fetch.
- Make a todo list first.
- You **must** cite and link every issue, including the `CLAUDE.md` excerpt when the violation is guideline-based.

## Tuning

- **Threshold (default 80).** To change it, edit this file's "Filter" step.
- **Add reviewers.** Append agents for security, performance, accessibility, or doc quality as the project demands.

## Requirements

- Git repository with a GitHub remote
- `gh` CLI installed and authenticated (`gh auth login`)
- Optional but strongly recommended: `CLAUDE.md` / `AGENTS.md` files describing project guidelines
