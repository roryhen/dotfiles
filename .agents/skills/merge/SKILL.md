---
name: merge
description: Commit, rebase, and merge the current branch.
disable-model-invocation: true
allowed-tools: Read, Bash, Glob, Grep
---

<!-- Source: raine/workmux v0.1.271. Local customization: scoped staging, Conventional Commit squash titles, shared-history consent, and explicit targets. -->

Do not stage secrets/unrelated files or fetch/push implicitly. Never merge from
the target branch itself. Ask if the target is ambiguous. If a branch has been
published/shared, obtain consent before rebase/squash or other history rewrites.

**Arguments:** `$ARGUMENTS`

Check the arguments for flags:

- `--keep`, `-k` → pass `--keep` to `workmux merge` (keeps the worktree and tmux window after merging)
- `--no-verify`, `-n` → pass `--no-verify` only when explicitly requested
- `--preserve-commits` → retain individual commits instead of manually squashing

Remove only recognized flags from arguments; an explicit remaining local branch
is the target. Ask about unknown flags; do not silently skip hooks.

Commit, rebase, and merge the current branch.

This command finishes work on the current branch by:

1. Reviewing and committing only relevant changes
2. Rebasing onto the base branch
3. Running `workmux merge` to merge and clean up

## Step 1: Commit

Check staged, unstaged, and untracked changes with `git status --porcelain`.
Review the diff and stage only relevant, non-secret paths explicitly. Review
`git diff --cached` and commit with a manually written message matching project
rules. Partners Hub requires Conventional Commits, e.g. `fix(scope): ...`.
Do not automatically commit unrelated edits. Skip committing if clean; resolve
remaining changes safely before rebasing/merging.

## Step 2: Rebase

Get the base branch from git config:

```
git config --local --get "branch.$(git branch --show-current).workmux-base"
```

Use an explicit target argument when supplied. Otherwise use the saved local
base, then resolve the configured/local default branch (`origin/HEAD`'s local
branch, `main`, or `master`). Verify that the local target exists; do not fetch
to resolve it. If the intended target is uncertain, ask.

Rebase onto the local base branch (do NOT fetch from origin first):

```
git rebase <base-branch>
```

IMPORTANT: Do NOT run `git fetch`. Do NOT rebase onto `origin/<branch>`. Only rebase onto the local branch name (e.g., `git rebase main`, not `git rebase origin/main`).

If conflicts occur:

- BEFORE resolving any conflict, understand what changes were made to each
  conflicting file in the base branch
- For each conflicting file, run `git log -p -n 3 <base-branch> -- <file>` to
  see recent changes to that file in the base branch
- The goal is to preserve BOTH the changes from the base branch AND our branch's
  changes
- After resolving each conflict, stage the file and continue with
  `git rebase --continue`
- If a conflict is too complex or unclear, ask for guidance before proceeding

## Step 3: Merge

Unless `--preserve-commits` was requested, manually squash feature commits into
one reviewed commit. Confirm `git merge-base --is-ancestor <target> HEAD`, review
`git log <target>..HEAD` and the net diff, then (only if multiple commits remain)
use `git reset --soft <target>`, inspect `git diff --cached`, and write a
Conventional Commit message. Do not use `git reset --hard`.

Run: `workmux merge <worktree-or-branch> --into <target> --rebase [--keep] [--no-verify]`.
The branch has already been reviewed/rebased; this integrates it with a
fast-forward and avoids an extra merge commit. Include `--keep`/`--no-verify`
only when requested. Do not skip other hooks silently.

Report local integration and cleanup separately from any remote push/PR merge.
A local Workmux merge does not merge a GitHub PR. Never force-push without
explicit authorization.
