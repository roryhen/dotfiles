---
name: rebase
description: Rebase the current feature branch onto the local default branch or an explicit target.
disable-model-invocation: true
---

Rebase the current feature branch. Arguments: $ARGUMENTS

- No argument: `wt step rebase` (uses the local default branch, usually main).
- A local branch or commit: `wt step rebase <target>`.
- `origin`: fetch origin, then rebase onto `origin/$(wt config state default-branch)`.
- `origin/<branch>`: fetch origin, then rebase onto that remote-tracking ref.

Inspect `git status --porcelain` before doing anything. If there are local
changes, stash them with `git stash push --include-untracked -m "worktrunk
rebase"`, remembering whether this invocation made a stash. If stashing
fails, stop. Never touch a pre-existing stash. On a fetch/target-resolution
failure before rebasing, restore only the stash this invocation created.

If rebasing conflicts, inspect recent changes to the conflicting files on the
target (`git log -p -n 3 <target> -- <file>`), preserve changes from both sides,
stage resolutions and run `git rebase --continue`. If the conflict cannot be
resolved safely, ask for guidance. Do not restore the stash until the rebase
completes; if restoring it conflicts, retain the stash and report the issue.

After a successful rebase, restore this invocation's stash with
`git stash pop --index`. This skill updates the feature branch; it does not
merge it into main or push it to a remote.
