---
name: worktrunk
description: Reference for managing Git worktrees and local merges with Worktrunk.
---

Worktrunk manages Git worktrees; it does not manage tmux panes, agents or
terminal sessions. Run `wt` from the intended repository. In an interactive
zsh shell the installed wrapper changes the working directory on switch;
inside an agent shell tool use `--no-cd`, `-C <repo>`, or the tool's workdir.

| Task | Command |
| --- | --- |
| New branch from default | `wt switch --create feature` |
| Branch from current HEAD | `wt switch --create feature --base=@` |
| Open branch/picker | `wt switch feature` / `wt switch` |
| Open PR branch | `wt switch pr:123` |
| List including branch status | `wt list` |
| Rebase feature onto local main | `wt step rebase main` |
| Squash+rebase+merge locally | `wt merge main` |
| Remove worktree if safe | `wt remove feature` |
| Keep branch on removal | `wt remove --no-delete-branch feature` |

`wt merge` defaults to squash + rebase + local merge + cleanup. It does NOT
fetch or push. The `/merge` skill uses a manually titled squash commit instead
of Worktrunk's automatic message; `/rebase` updates a feature branch without
merging it. Use `wt merge --no-squash` when history must be preserved.

Worktrunk's default path is a sibling like `repo.feature`. This machine's
`~/.config/worktrunk/config.toml` has personal pre-start copy/symlink hooks
for Partners Hub and a background `pnpm install` hook. Inspect the project's
hook configuration before modifying it; never expose `.env.local` or Vercel
credentials. See https://worktrunk.dev/ for current commands and options.
