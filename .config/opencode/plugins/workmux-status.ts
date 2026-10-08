// Local OpenCode 2.0.24 adapter for Workmux v0.1.271 (issues #290/#291).
// Requires a direct `opencode --standalone` pane; not a shared-service mapper.
import { spawn } from 'node:child_process';
import { realpathSync } from 'node:fs';

// Structural types cover only the public V2 APIs this local adapter uses.
// No change to the existing V1 SDK/package dependencies is required.
type SessionInfo = { parentID?: string; location: { directory: string } };
type StatusEvent = {
  type: string;
  location?: { directory: string };
  data: {
    sessionID?: string;
    parentID?: string;
    status?: { type: string };
    form?: { sessionID?: string };
  };
};
type Context = {
  location: { directory: string };
  session: {
    get(input: { sessionID: string }): Promise<SessionInfo>;
    hook(kind: 'prompt', callback: (event: {
      sessionID: string;
      prompt: { text?: string };
    }) => Promise<void>): Promise<unknown>;
  };
  event: { subscribe(options: { signal: AbortSignal }): AsyncIterable<StatusEvent> };
};

function canonical(path: string): string {
  try { return realpathSync(path); } catch { return path; }
}

export default {
  id: 'workmux-status',
  async setup(ctx: Context) {
    const directory = canonical(ctx.location.directory);
    // V2 may load plugins for both the main repo and a linked worktree. Only
    // the instance for this private server's launch directory owns the pane.
    if (!process.env.TMUX_PANE || directory !== canonical(process.cwd())) return;

    function command(args: string[], prompt?: string): Promise<void> {
      return new Promise((resolve, reject) => {
        const child = spawn('workmux', args, {
          cwd: directory,
          env: process.env,
          stdio: ['pipe', 'ignore', 'pipe'],
        });
        let settled = false;
        const timer = setTimeout(() => { child.kill(); finish(new Error('command timed out')); }, 10000);
        function finish(error?: Error) {
          if (settled) return;
          settled = true;
          clearTimeout(timer);
          if (error) reject(error); else resolve();
        }
        // Drain diagnostics, but do not log hook input, prompts, or credentials.
        child.stderr.resume();
        child.stdin.on('error', () => {});
        child.on('error', (error: Error) => finish(error));
        child.on('close', (code: number | null) => finish(code === 0 ? undefined : new Error(`exit ${code}`)));
        child.stdin.end(prompt === undefined ? '' : JSON.stringify({ prompt }));
      });
    }

    try {
      await command(['register-agent']);
    } catch (error) {
      console.error('[workmux-status] registration failed:', String(error));
      return;
    }

    const statuses = new Map<string, string>();
    const acceptsBusy = new Map<string, boolean>();
    const sessions = new Map<string, SessionInfo>();
    const deleted = new Set<string>();
    let reported = '';
    let pendingPrompt: string | undefined;
    let queue = Promise.resolve();

    function report(status: string, prompt?: string): Promise<void> {
      queue = queue.then(async () => {
        if (status === reported && prompt === undefined) return;
        await command(['set-window-status', status], prompt);
        reported = status;
      }).catch((error) => {
        console.error('[workmux-status] status update failed:', String(error));
      });
      return queue;
    }

    async function session(id: string): Promise<SessionInfo | undefined> {
      if (deleted.has(id)) return;
      const cached = sessions.get(id);
      if (cached) return cached;
      try {
        const info = await ctx.session.get({ sessionID: id });
        if (canonical(info.location.directory) !== directory) return;
        sessions.set(id, info);
        return info;
      } catch { return; }
    }

    async function setStatus(id: string, status: string): Promise<void> {
      if (!await session(id)) return;
      if (status === 'working' && acceptsBusy.get(id) === false) return;
      if (status === 'done' && !statuses.has(id)) return;
      statuses.set(id, status);
      acceptsBusy.set(id, status !== 'done');
      await aggregate();
    }

    async function aggregate(): Promise<void> {
      const values = [...statuses.values()];
      let status = 'done';
      if (values.includes('waiting')) status = 'waiting';
      else if (values.includes('working')) status = 'working';
      const prompt = status === 'working' ? pendingPrompt : undefined;
      if (prompt !== undefined) pendingPrompt = undefined;
      await report(status, prompt);
    }

    // V2 registers hooks/subscriptions during setup; returning V1 hooks does
    // nothing. Capture the root user's prompt without modifying/submitting it.
    await ctx.session.hook('prompt', async (event) => {
      const info = await session(event.sessionID);
      if (!info) return;
      acceptsBusy.set(event.sessionID, true);
      if (!info.parentID && event.prompt.text?.trim()) {
        pendingPrompt = event.prompt.text;
        if (reported === 'working') {
          const prompt = pendingPrompt;
          pendingPrompt = undefined;
          await report('working', prompt);
        }
      }
    });
    await report('done');

    const controller = new AbortController();
    void (async () => {
      for await (const event of ctx.event.subscribe({ signal: controller.signal })) {
        if (event.location && canonical(event.location.directory) !== directory) continue;
        const id = event.data.sessionID ?? event.data.form?.sessionID;
        if (!id) continue;
        switch (event.type) {
          case 'session.created':
            sessions.delete(id);
            acceptsBusy.set(id, true);
            break;
          // V2's public stream emits durable execution events rather than
          // the legacy session.status events used by the upstream V1 plugin.
          case 'session.execution.started':
            acceptsBusy.set(id, true);
            await setStatus(id, 'working');
            break;
          case 'session.retry.scheduled':
            await setStatus(id, 'working');
            break;
          case 'session.status':
            if (event.data.status?.type === 'busy' || event.data.status?.type === 'retry') {
              await setStatus(id, 'working');
            } else if (event.data.status?.type === 'idle') {
              await setStatus(id, 'done');
            }
            break;
          case 'permission.asked':
          case 'form.created':
            await setStatus(id, 'waiting');
            break;
          case 'permission.replied':
          case 'form.replied':
          case 'form.cancelled':
            await setStatus(id, 'working');
            break;
          case 'session.execution.succeeded':
          case 'session.execution.failed':
          case 'session.execution.interrupted':
          case 'session.idle':
            await setStatus(id, 'done');
            break;
          case 'session.deleted':
            deleted.add(id);
            sessions.delete(id);
            acceptsBusy.delete(id);
            statuses.delete(id);
            await aggregate();
            break;
          default:
            break; // Other V2 events do not change agent status.
        }
      }
    })().catch((error) => {
      if (!controller.signal.aborted) console.error('[workmux-status] event stream failed:', String(error));
    });
    return () => controller.abort();
  },
};
