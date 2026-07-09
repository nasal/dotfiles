import { describe, expect, test } from "bun:test"

import { classifyCommand } from "./guardrails"

describe("classifyCommand", () => {
  test.each([
    "git push --force origin main",
    "git push origin main --force-with-lease",
    "git push -f",
  ])("blocks force pushes: %s", (command) => {
    expect(classifyCommand(command)).toContain("Force-pushing")
  })

  test.each([
    "git commit --no-verify -m bad",
    "git commit -m bad --no-verify",
    "git commit -n -m bad",
  ])("blocks skipped hooks: %s", (command) => {
    expect(classifyCommand(command)).toContain("Skipping Git hooks")
  })

  test.each([
    "git push origin main",
    "git commit -m safe",
    "printf '%s' --force",
  ])("allows non-forbidden commands: %s", (command) => {
    expect(classifyCommand(command)).toBeNull()
  })
})
