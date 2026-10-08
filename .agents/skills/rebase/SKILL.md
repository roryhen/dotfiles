---
name: rebase
description: Rebase the current branch with smart conflict resolution.
disable-model-invocation: true
allowed-tools: Read, Bash, Glob, Grep
---

<!-- Source: raine/workmux v0.1.271. Local customization: default-branch targeting, explicit remote fetch, shared-history consent, and stash ownership. -->

Ask before rewriting a published/shared branch. This skill never merges or
pushes. Workmux's `rebase` positional argument selects a worktree, not a target
commit; use `git rebase <target>` for explicit target semantics.

Rebase the current branch.

Arguments: $ARGUMENTS

Behavior:

- No arguments: rebase on the local default branch, not a saved stacked base.
  Resolve configured `main_branch`, the local branch named by `origin/HEAD`, or
  existing `main`/`master`; verify it exists and ask if ambiguous. Do not fetch.
- "origin": explicitly fetch origin, then rebase on origin/<default-branch>.
- "origin/branch": explicitly fetch origin, then rebase on that tracking ref.
- A local branch or commit: rebase on that target without fetching. A slash in
  a local branch name does not by itself authorize a remote fetch.

Steps:

1. Check for local changes with `git status --porcelain`:
   - If the working tree has staged, unstaged, or untracked changes, stash them
     with `git stash push --include-untracked -m "workmux rebase"`.
   - Record whether this invocation created a stash and its exact object ID.
     Existing stash entries must remain untouched; do not restore a different
     stash if another invocation changes the stack.
   - If stashing fails, stop before fetching or rebasing.
2. Parse arguments:
   - No args → resolve the local default branch as above; no fetch.
   - Explicit `origin/<branch>` → fetch origin; target is that tracking ref.
   - Just `origin` → fetch origin; target is origin/<resolved-default-branch>.
   - Anything else → validate that local branch/commit with
     `git rev-parse --verify <target>^{commit}`; no fetch.
3. If fetching, run: `git fetch <remote>`. If fetching or target resolution
   fails before the rebase begins, restore the stash created in step 1 before
   stopping.
4. Run: `git rebase <target>`
5. If conflicts occur, handle them carefully (see below)
6. Continue until rebase is complete
7. If step 1 created a stash, find its exact object ID in `git stash list` and
   restore only that entry with `git stash pop --index <matching-stash-ref>`:
   - Restore the stash only after the rebase succeeds.
   - If restoration conflicts, preserve the stash, report the conflicts, and
     leave the affected files for manual resolution.

Handling conflicts:

- BEFORE resolving any conflict, understand what changes were made to each
  conflicting file in the target branch
- For each conflicting file, run `git log -p -n 3 <target> -- <file>` to see
  recent changes to that file in the target branch
- The goal is to preserve BOTH the changes from the target branch AND our
  branch's changes
- After resolving each conflict, stage the file and continue with
  `git rebase --continue`
- If a conflict is too complex or unclear, ask for guidance before proceeding
