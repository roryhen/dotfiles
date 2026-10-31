/**
 * Claude plan usage widget for pi.
 *
 * After each settled task, runs Claude Code's `/usage` non-interactively and shows
 * the session and weekly usage as bars below the prompt. `/usage` is a local
 * report, so this makes no model call.
 */

import type { ExtensionAPI, ExtensionContext } from "@earendil-works/pi-coding-agent";

const WIDGET_KEY = "claude-usage";
const BAR_WIDTH = 20;
const TIMEOUT_MS = 60_000;
const MAX_ATTEMPTS = 3;
const RETRY_DELAY_MS = 5_000;
const MAX_ERROR_CHARS = 120;

const RESET = "\x1b[0m";
const DIM = "\x1b[2m";

type UsageWindow = { label: string; percent: number; resets: string };

const WINDOW_PATTERNS: Array<[label: string, pattern: RegExp]> = [
  ["Session", /Current session:\s*(\d+)%\s*used(?:\s*·\s*resets\s*(.+))?/i],
  ["Week", /Current week \(all models\):\s*(\d+)%\s*used(?:\s*·\s*resets\s*(.+))?/i],
];

export function parseUsage(report: string): UsageWindow[] {
  const windows: UsageWindow[] = [];
  for (const [label, pattern] of WINDOW_PATTERNS) {
    const match = report.match(pattern);
    if (match) windows.push({ label, percent: Number(match[1]), resets: match[2]?.trim() ?? "" });
  }
  return windows;
}

function colorFor(percent: number): string {
  if (percent >= 90) return "\x1b[31m";
  if (percent >= 70) return "\x1b[33m";
  return "\x1b[32m";
}

function renderLine({ label, percent, resets }: UsageWindow): string {
  const clamped = Math.max(0, Math.min(100, percent));
  const filled = Math.round((clamped / 100) * BAR_WIDTH);
  const bar = `${colorFor(clamped)}${"█".repeat(filled)}${DIM}${"░".repeat(BAR_WIDTH - filled)}${RESET}`;
  // Drop the timezone suffix so the line stays short in narrow terminals.
  const shortReset = resets.replace(/ \(.*\)$/, "");
  const suffix = shortReset ? `  ${DIM}resets ${shortReset}${RESET}` : "";
  return `${label.padEnd(8)} ${bar} ${String(clamped).padStart(3)}%${suffix}`;
}

// Left-aligned, one row per line; only rendered lines take space.
function leftAligned(lines: string[]) {
  return {
    render(): string[] {
      return lines.map((line) => ` ${line}`);
    },
    invalidate() {},
  };
}

// Claude Code's own /usage reads this endpoint, but `claude -p /usage` can print its report
// before the request returns and omit the limit lines. Call it directly with Claude Code's
// OAuth token instead. The token is only read, never refreshed: refreshing rotates the refresh
// token and would invalidate the copy Claude Code holds.
const USAGE_ENDPOINT = "https://api.anthropic.com/api/oauth/usage";
const KEYCHAIN_SERVICE = "Claude Code-credentials";

function formatResetsAt(iso: string): string {
  const date = new Date(iso);
  if (Number.isNaN(date.getTime())) return "";
  const day = date.toLocaleDateString("en-US", { month: "short", day: "numeric" });
  const time = date
    .toLocaleTimeString("en-US", { hour: "numeric", minute: "2-digit" })
    .replace(":00", "")
    .replace(" ", "")
    .toLowerCase();
  return `${day} at ${time}`;
}

async function fetchUsageFromApi(pi: ExtensionAPI): Promise<UsageWindow[]> {
  const keychain = await pi.exec("security", ["find-generic-password", "-s", KEYCHAIN_SERVICE, "-w"], {
    timeout: 10_000,
  });
  if (keychain.code !== 0) throw new Error("Claude Code login not found in keychain");
  const oauth = JSON.parse(keychain.stdout)?.claudeAiOauth;
  if (typeof oauth?.accessToken !== "string") throw new Error("no Claude Code access token");
  if (typeof oauth.expiresAt === "number" && oauth.expiresAt <= Date.now()) throw new Error("Claude Code token expired");

  const response = await fetch(USAGE_ENDPOINT, {
    headers: { Authorization: `Bearer ${oauth.accessToken}`, "anthropic-beta": "oauth-2025-04-20" },
    signal: AbortSignal.timeout(15_000),
  });
  if (!response.ok) throw new Error(`usage API returned ${response.status}`);
  const data = (await response.json()) as Record<string, { utilization?: unknown; resets_at?: string } | undefined>;

  const windows: UsageWindow[] = [];
  for (const [label, key] of [["Session", "five_hour"], ["Week", "seven_day"]] as const) {
    const bucket = data[key];
    if (typeof bucket?.utilization === "number") {
      windows.push({ label, percent: Math.round(bucket.utilization), resets: bucket.resets_at ? formatResetsAt(bucket.resets_at) : "" });
    }
  }
  if (windows.length === 0) throw new Error("usage API returned no limits");
  return windows;
}

async function fetchUsageViaClaude(pi: ExtensionAPI): Promise<UsageWindow[]> {
  const result = await pi.exec("claude", ["-p", "/usage", "--output-format", "json"], { timeout: TIMEOUT_MS });
  if (result.code !== 0) throw new Error(result.stderr?.trim() || `claude exited with ${result.code}`);

  let parsed: { result?: string; is_error?: boolean };
  try {
    parsed = JSON.parse(result.stdout);
  } catch {
    throw new Error("claude /usage printed invalid JSON");
  }
  if (parsed.is_error || !parsed.result) throw new Error("claude /usage returned no result");

  const windows = parseUsage(parsed.result);
  if (windows.length === 0) throw new Error(`no usage lines in: ${parsed.result.replace(/\s+/g, " ").slice(0, 80)}`);
  return windows;
}

// Transient failures (e.g. concurrent claude processes refreshing auth) often clear on a
// second try, so retry a few times before reporting the error.
async function fetchUsage(pi: ExtensionAPI): Promise<UsageWindow[]> {
  try {
    return await fetchUsageFromApi(pi);
  } catch {
    // Fall back to the CLI below.
  }
  let lastError: unknown;
  for (let attempt = 1; attempt <= MAX_ATTEMPTS; attempt++) {
    try {
      return await fetchUsageViaClaude(pi);
    } catch (error) {
      lastError = error;
      if (attempt < MAX_ATTEMPTS) await new Promise((resolve) => setTimeout(resolve, RETRY_DELAY_MS));
    }
  }
  throw lastError;
}

export default function (pi: ExtensionAPI) {
  let refreshing = false;
  // `claude -p /usage` sometimes renders before its usage request returns, leaving out the
  // limit lines. Keep the last good reading so the widget stays useful when that happens.
  let lastGood: { lines: string[]; at: number } | undefined;

  function show(ctx: ExtensionContext, lines: string[]) {
    ctx.ui.setWidget(WIDGET_KEY, () => leftAligned(lines), { placement: "belowEditor" });
  }

  async function refresh(ctx: ExtensionContext) {
    if (!ctx.hasUI || refreshing) return;
    refreshing = true;
    try {
      const windows = await fetchUsage(pi);
      const lines = windows.map(renderLine);
      lastGood = { lines, at: Date.now() };
      show(ctx, lines);
    } catch (error) {
      if (lastGood) {
        const minutes = Math.round((Date.now() - lastGood.at) / 60_000);
        show(ctx, [...lastGood.lines, `${DIM}(stale, ${minutes}m ago)${RESET}`]);
        return;
      }
      const message = (error instanceof Error ? error.message : String(error)).slice(0, MAX_ERROR_CHARS);
      show(ctx, [`${DIM}Claude usage unavailable: ${message}${RESET}`]);
    } finally {
      refreshing = false;
    }
  }

  pi.on("session_start", (_event, ctx) => refresh(ctx));
  pi.on("agent_settled", (_event, ctx) => refresh(ctx));
}
