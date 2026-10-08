# Local Workmux / OpenCode V2 integration

Based on Workmux v0.1.271's status semantics; adapted for OpenCode 2.0.24.

- https://github.com/raine/workmux/issues/290: V2 requires a default `{ id, setup }` definition. The export wrapper alone loads but does not register agents on 2.0.24.
- The adapter uses V2's `ctx.session.hook("prompt", ...)`, async `ctx.event.subscribe(...)`, `event.data`, and durable `session.execution.*` events instead of V1's returned hooks and `$` helper. Node subprocesses call the unchanged Workmux CLI. No Workmux binary fork or existing package/dependency changes are required.
- Permission/form events map to waiting; all tracked parent/child sessions contribute to the aggregate status. Prompt content is passed to Workmux through stdin, not command arguments or diagnostic logs.
- https://github.com/raine/workmux/issues/291: Partners Hub uses `agent: opencode --standalone` so each pane has a private server with its own tmux identity. This is not a shared-service session mapper. The plugin instance only registers the private server's launch directory, avoiding duplicate main-repo/worktree instances. Existing shared sessions are not restarted.

## Verification

Two disposable agents passed registration and correct pane association, separate `working → done` transitions, unique no-file-edit prompts/replies via `workmux send`/`capture`, and bounded `workmux wait`. The idle agent's state and terminal remained unchanged when the other ran. Focused TypeScript validation passed with existing project tooling/Node typings.

To revalidate after an update, create two disposable standalone agent worktrees, send distinct no-tool/no-file-edit prompts, observe working/done for the targeted pane only, capture each reply, and run `workmux wait <name> --status done --timeout 120`. Loader success alone is insufficient.

## Updates

`workmux setup` or an upstream integration update may offer to overwrite this local adapter with bundled V1 code. Compare the new upstream integration before accepting it; preserve this adapter until native V2 support is verified. Do not replace it with only the #290 export wrapper or remove `--standalone` without rechecking identity/routing. The official global skills are installed once under `~/.agents/skills/`, not duplicated in agent-specific directories.
