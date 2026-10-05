---
name: merge
description: Manually squash, rebase, and locally merge a feature branch using Worktrunk.
disable-model-invocation: true
---

Arguments: $ARGUMENTS

By default, produce ONE reviewed, manually titled commit on the feature branch
and integrate it into the LOCAL default branch. Worktrunk does not fetch or
push remote branches. Ask before merging if the intended target is ambiguous.

Options: `--keep` preserves the worktree/branch after merge (`--no-remove`);
`--preserve-commits` keeps the feature branch's separate commits rather than
squashing. Do not silently translate old `workmux` flags such as `--no-verify`
or `--notification`; Worktrunk has different options.

1. Inspect `git status --porcelain`, current branch, base and diff. Never merge
   from the default branch itself. Review all staged, unstaged and untracked
   changes; do not stage secrets or unrelated files. If needed, stage and
   commit with a meaningful manually written message. Follow project rules:
   Partners Hub requires Conventional Commits (`feat(scope): ...`, etc.).
   If the branch is already published/shared, ask before any rebase or squash
   that would rewrite its history.
2. Rebase the feature branch onto the LOCAL target (`wt step rebase <target>`).
   Resolve conflicts carefully; leave unresolved conflicts for user guidance.
   Do not fetch unless explicitly asked. Confirm a clean worktree afterward.
3. Unless `--preserve-commits` was requested, manually squash the feature
   branch's commits into one: first confirm `<target>` is an ancestor with
   `git merge-base --is-ancestor <target> HEAD`. Review `git log <target>..HEAD`
   and the net diff. If there is more than one feature commit, explain that
   squash rewrites branch history, then run `git reset --soft <target>`, review
   `git diff --cached`, and `git commit` with a manually written message that
   follows the project's commit rules. Do not use `git reset --hard`.
4. Run `wt merge <target> --no-squash --no-commit --no-rebase` (add
   `--no-remove` if `--keep` was requested). The branch is already clean,
   rebased and, by default, manually squashed; these flags prevent Worktrunk
   from generating a commit message or rewriting the reviewed history again.
   Do not pass `--no-hooks` without an explicit request to skip hooks.
5. Report the local merge, cleanup outcome, and whether a remote push/PR merge
   remains. A local `wt merge` does NOT merge a GitHub PR.

Never force-push without explicit authorization.
