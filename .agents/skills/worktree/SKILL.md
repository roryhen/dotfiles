---
name: worktree
description: Create or navigate Git worktrees with Worktrunk.
disable-model-invocation: true
---

Use `wt` for worktree management. Run it from the intended repository; for a
different repository use the shell tool's working directory or `wt -C <path>`.

For an explicitly requested new worktree, choose a descriptive branch name and
run `wt switch --create --no-cd <branch>` (add `--base=@` only when the user wants
to branch from the current branch instead of the default branch). `--no-cd`
keeps the agent's current shell/location unchanged; use the result or `wt list`
to report the worktree path. Do not create another worktree when a matching one
already exists: use `wt switch --no-cd <branch>` instead.

In an interactive shell, `wt switch <branch>` navigates to an existing worktree
and `wt switch` opens the picker. Start `nvim .`, `opencode`, or `pi` manually
after entering the worktree. In an interactive terminal, use
`wt switch -x opencode <branch>` to launch OpenCode or
`wt switch -x pi <branch>` to launch Pi. Do not launch an interactive TUI from
a non-interactive shell tool. Worktrunk does not create tmux windows or provide
agent send/wait/capture commands.

Never force-delete or relocate a worktree just to switch managers. Use
`wt list` and `git worktree list` to inspect existing checkouts first.
