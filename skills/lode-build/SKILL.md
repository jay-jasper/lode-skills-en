---
name: lode-build
description: "Lodestar mainline ⑤ — project development. Build Face by Face per the DEV-PLAN, each Face running the four-step audit loop until it passes. Use when the dev plan is ready and it's time to write the implementation. Trigger: /lode-build"
---

# Dev Builder (Project Development)

Mainline step ⑤. Build **Face by Face** per `DEV-PLAN.md`. The point is the **loop**: once a Face is written, you must fan out an independent subagent to review it; it's done only when the review passes, and if it doesn't, fix until it does.

## Usage (when to use)

- `DEV-PLAN.md` is confirmed; start implementing.
- A Face's code needs writing / filling in / tuning to acceptance.
- Usually paired with a **Go** (see `lode-go`) to enter the self-driving loop.

## At dev start, lay down `verify.sh` (the vehicle for the deterministic gate)

Before touching the first Face, wrap **this project's build + test commands** in `.lode/<project>/verify.sh` (all pass → `exit 0`, any failure → non-zero).
This hands "build with zero errors / all tests pass" — a **deterministic judgment** — to the Stop gate to actually run, instead of stuffing it into model self-assessment; the model shouldn't "recite" its way to a passing build. Language-agnostic: what commands go in the script is the project's call (e.g. `npm run build && npm test`).

## Four-step audit (mandatory per Face)

The first two steps are **deterministic** — handed to the hook to actually run; the last two are **uncertain** — judged by a human/subagent:

1. **Build verification (deterministic · hook)** — `verify.sh` build exit code is 0.
2. **Test completeness (deterministic · hook)** — unit + end-to-end + UI-click tests are complete and `verify.sh` is all green.
3. **Code Review (judgment · subagent)** — fan out a clean-head subagent to review (see `lode-review`), covering code quality, alignment with the Spec, and for web projects a11y/responsive/key-page performance.
4. **Functional test (judgment)** — the actual feature runs through per the acceptance method.

All four pass → local commit as a rollback point (**no push**) → write the review conclusion into `.lode/<project>/REVIEW_PASSED` (note the reviewed Face/commit) → write the audit report → only then is this Face Done.

## Done (what counts as acceptable)

For the current Face:
- Meets the done criteria written in the plan.
- Passes the four-step audit, and appends the change to `.lode/<project>/CHANGELOG.md` (what/why/blast-radius).
- After each Face passes review, make a **local commit** (no push) as a rollback point — if a long self-driving loop crashes, you can fall back to the last runnable Face.
- When design or requirements change, write back to `Design-Brief.md` / `Product-Spec.md` / `DEV-PLAN.md` to keep docs in sync.

## Guardrails (red lines)

- **Advance one Face at a time**, get it running before the next; **one Session develops one feature**, next feature opens a new Session, keeping each Session's context small and clean.
- **Reuse existing design/prototype code** directly, don't rewrite from scratch — rewriting burns tokens and can't reproduce the original design.
- Locate and fix your own failing self-tests; don't leave red tests for the review or the human.
- Obey every rule in `CLAUDE.md` (each was earned by a real pitfall).
- Only fan out subagents in parallel for mutually independent Faces; grant capability, don't pile up tools, and don't smuggle in out-of-plan "while-I'm-here optimizations."
