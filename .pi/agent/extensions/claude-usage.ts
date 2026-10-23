/**
 * Claude plan usage widget for pi.
 *
 * After each settled task, runs Claude Code's `/usage` non-interactively and shows
 * the session and weekly usage as bars below the prompt. `/usage` is a local
 * report, so this makes no model call.
 */

import type { ExtensionAPI, ExtensionContext } from "@earendil-works/pi-coding-agent";
import { visibleWidth } from "@earendil-works/pi-tui";

const WIDGET_KEY = "claude-usage";
const BAR_WIDTH = 20;
const TIMEOUT_MS = 60_000;
const MAX_ERROR_CHARS = 120;

const RESET = "\x1b[0m";
const DIM = "\x1b[2m";

type UsageWindow = { label: string; percent: number; resets: string };

const WINDOW_PATTERNS: Array<[label: string, pattern: RegExp]> = [
  ["Session", /Current session: (\d+)% used · resets (.+)/],
  ["Week", /Current week \(all models\): (\d+)% used · resets (.+)/],
];

export function parseUsage(report: string): UsageWindow[] {
  const windows: UsageWindow[] = [];
  for (const [label, pattern] of WINDOW_PATTERNS) {
    const match = report.match(pattern);
    if (match) windows.push({ label, percent: Number(match[1]), resets: match[2].trim() });
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
  return `${label.padEnd(8)} ${bar} ${String(clamped).padStart(3)}%  ${DIM}resets ${shortReset}${RESET}`;
}

// Right-aligns the whole block as one unit so the bars stay in a column. Only the
// rendered lines take space, so the widget no longer leaves blank rows behind.
function rightAligned(lines: string[]) {
  return {
    render(width: number): string[] {
      const blockWidth = Math.min(width, Math.max(0, ...lines.map((line) => visibleWidth(line))));
      const pad = " ".repeat(Math.max(0, width - blockWidth));
      return lines.map((line) => pad + line);
    },
    invalidate() {},
  };
}

async function fetchUsage(pi: ExtensionAPI): Promise<UsageWindow[]> {
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
  if (windows.length === 0) throw new Error("no usage lines in /usage output");
  return windows;
}

export default function (pi: ExtensionAPI) {
  let refreshing = false;

  function show(ctx: ExtensionContext, lines: string[]) {
    ctx.ui.setWidget(WIDGET_KEY, () => rightAligned(lines), { placement: "belowEditor" });
  }

  async function refresh(ctx: ExtensionContext) {
    if (!ctx.hasUI || refreshing) return;
    refreshing = true;
    try {
      const windows = await fetchUsage(pi);
      show(ctx, windows.map(renderLine));
    } catch (error) {
      const message = (error instanceof Error ? error.message : String(error)).slice(0, MAX_ERROR_CHARS);
      show(ctx, [`${DIM}Claude usage unavailable: ${message}${RESET}`]);
    } finally {
      refreshing = false;
    }
  }

  pi.on("session_start", (_event, ctx) => refresh(ctx));
  pi.on("agent_settled", (_event, ctx) => refresh(ctx));
}
