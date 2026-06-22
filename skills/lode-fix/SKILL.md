---
name: lode-fix
description: "Lodestar extension — Bug fixing. Reproduce → locate → minimal fix → regression-verify. Use when a bug, test failure, review rejection, or production anomaly needs fixing. Trigger: /lode-fix"
---

# Bug Fixer

Extension skill. Systematically fix defects: reproduce first, then locate, make a minimal fix, regression-verify.

## Usage (when to use)

- Self-test or tests fail; behavior doesn't match expectations.
- A blocking item kicked back by `lode-review`.
- A production / runtime anomaly needs investigating and fixing.

## Done (what counts as acceptable)

- **Stably reproduce** the problem first (a failing test case that reproduces it is best).
- Locate the **root cause**, not the symptom; explain why it goes wrong.
- Make a **minimal fix**; don't refactor unrelated code while you're at it.
- Regression: the original failing case turns green, and all existing tests pass.
- If this was a real pitfall worth remembering → prompt `/lode-evolve` to distill it into a rule.

## Guardrails (red lines)

- Don't guess: no reproduction means no localization — don't blind-patch.
- Fix the implementation, don't change tests to mask the problem (unless the test itself is wrong).
- Fix one root cause at a time; don't smuggle in unrelated changes that widen the blast radius.
- After fixing, run the full set of related tests to confirm no new red was introduced.

## → Next
Fixed → back to `/lode-build` to wrap up (four-step audit + gate); if it is a pitfall worth remembering → `/lode-evolve` to distill a rule.
