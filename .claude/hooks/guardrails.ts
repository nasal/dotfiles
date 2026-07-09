type HookInput = {
  tool_input?: {
    command?: unknown
    cmd?: unknown
  }
}

const forbiddenCommands = [
  {
    pattern:
      /\bgit\s+push\b(?=[^;&|\n]*(?:--force(?:-with-lease)?|-f)(?=\s|$))[^;&|\n]*/,
    reason: "Force-pushing is disabled by the global Git guardrail.",
  },
  {
    pattern: /\bgit\s+commit\b(?=[^;&|\n]*(?:--no-verify|-n)(?=\s|$))[^;&|\n]*/,
    reason: "Skipping Git hooks is disabled by the global verification guardrail.",
  },
]

export function classifyCommand(command: string): string | null {
  return forbiddenCommands.find(({ pattern }) => pattern.test(command))?.reason ?? null
}

function readCommand(input: HookInput): string {
  const command = input.tool_input?.command ?? input.tool_input?.cmd

  if (Array.isArray(command)) {
    return command.join(" ")
  }

  return typeof command === "string" ? command : ""
}

if (import.meta.main) {
  const input = JSON.parse(await Bun.file("/dev/stdin").text()) as HookInput
  const reason = classifyCommand(readCommand(input))

  if (reason) {
    console.log(
      JSON.stringify({
        hookSpecificOutput: {
          hookEventName: "PreToolUse",
          permissionDecision: "deny",
          permissionDecisionReason: reason,
        },
      }),
    )
  }
}
