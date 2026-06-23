---
name: lode-build
description: "Lodestar mainline ⑤ — project development. Build slice by slice per the dev-plan, each slice running the four-step audit loop until it passes. Use when the dev plan is ready and it's time to write the implementation. Trigger: /lode-build"
---

# Dev Builder (Project Development)

Mainline step ⑤. Build **slice by slice** per the **latest dev plan** (`ls -t .lode/plan/*.md | head -1`). The point is the **loop**: once a slice is written, you must fan out an independent subagent to review it; it's done only when the review passes, and if it doesn't, fix until it does.

## Usage (when to use)

- The latest dev plan (newest under `.lode/plan/`) is confirmed; start implementing.
- A slice's code needs writing / filling in / tuning to acceptance.
- Usually paired with an **order** (see `lode-order`) to enter the self-driving loop.

## At dev start: arm the gate + write `verify.sh` (the vehicle for the deterministic gate — zero user judgment)

Before touching the first slice, **build automatically** does two things:

1. **Arm the gate**: `touch .lode/.building` — this zero-content marker tells the Stop gate "dev has started, bite now" (without it, during spec/plan stage the gate stays dormant).
2. **Write `verify.sh`**: into `.lode/verify.sh`, **this project's real build + test commands** (all pass → `exit 0`, any failure → non-zero) — **not a skeleton for the user to fill**:
   - Where the commands come from: changing existing code → the "how to run" section of `architecture.md` (recon already found the real commands); from scratch → the stack you chose (e.g. `npm run build && npm test`).
   - This hands "build with zero errors / all tests pass" — a **deterministic judgment** — to the Stop gate to actually run, instead of model self-assessment.
   - The gate runs it at wrap-up as a backstop: if `.building` is armed but verify.sh is missing or left as an unconfigured placeholder, wrap-up is hard-blocked.

## Four-step audit (mandatory per slice)

The first two steps are **deterministic** — handed to the hook to actually run; the last two are **uncertain** — judged by a human/subagent:

1. **Build verification (deterministic · hook)** — `verify.sh` build exit code is 0.
2. **Test completeness (deterministic · hook)** — unit + end-to-end + UI-click tests are complete and `verify.sh` is all green; **tests must cover this slice's "acceptance scenarios"** (the ones defined in plan before building), not weak tests you patch in after writing the code. Write the tests covering the acceptance scenarios first, then make them green.
3. **Code Review (judgment · subagent)** — fan out a clean-head subagent to review (see `lode-review`), covering code quality, alignment with the Spec, and for web projects a11y/responsive/key-page performance.
4. **Functional test (judgment)** — run through each of the slice's **acceptance scenarios** for real (not a vague "it runs"); **demo it if you can** (start a server / screenshot / a run command), not just a green test report.

All four pass → local commit as a rollback point **and this slice's record** (**no push**; the commit message states "what / why / blast radius" — in a git project this commit IS the slice log, no separate changelog; **non-git projects only** append the same content to `.lode/changelog.md` as a fallback) → write the review conclusion into `.lode/review-passed` (note the reviewed slice/commit, plus a line `tree: <current code fingerprint>` — just copy the line the gate prints when it blocks; the gate verifies it matches current code, so edits-after-review invalidate it) → **update `docs/architecture.md`** (sync this slice's structure/conventions/new interfaces into the current-state map so it stays a live, up-to-date map — the next goal's spec uses it as the current state directly, no need to re-scan code you just wrote) → write the audit report → only then is this slice Done.

## Done (what counts as acceptable)

For the current slice:
- Meets the done criteria written in the plan.
- Passes the four-step audit, and records this slice: **git projects write it into the per-slice commit message** (what / why / blast-radius); **non-git projects only** append to `.lode/changelog.md` as a fallback.
- After each slice passes review, make a **local commit** (no push) as a rollback point — if a long self-driving loop crashes, you can fall back to the last runnable slice.
- When design or requirements change, keep docs in sync: update `docs/spec.md` **in place**; for design/plan changes **save a new version** (`.lode/design/<feature>-<ts>.md`, `.lode/plan/<feature>-<ts>.md` — never overwrite the old; downstream reads newest).
- **Reconcile against `docs/spec.md` at wrap-up**: cross-check the built result item by item — ① built something the spec lacks → write it back into the spec or cut it; ② spec has it but it wasn't built → build it or explicitly move to "deferred"; ③ built differently than the spec → fix the code to align, or (intended evolution) update the spec + one line in `docs/spec-changelog.md`. **Once reconciled, the spec must equal the built result.**
- Keep the current slice synced in the **native todo list** throughout (mark in-progress when you start, tick done only when all four steps pass), so the user sees progress live in the UI; **ticking without passing the gate doesn't count** — passed is judged by `verify.sh` / review for real.

## Guardrails (red lines)

- **Advance one slice at a time**, get it running before the next; **one Session develops one feature**, next feature opens a new Session, keeping each Session's context small and clean.
- **Reuse existing design/prototype code** directly, don't rewrite from scratch — rewriting burns tokens and can't reproduce the original design.
- Locate and fix your own failing self-tests; don't leave red tests for the review or the human.
- Obey every rule in `CLAUDE.md` (each was earned by a real pitfall).
- Only fan out subagents in parallel for mutually independent slices; grant capability, don't pile up tools, and don't smuggle in out-of-plan "while-I'm-here optimizations."

## → Next
This slice is Done → more slices? do the next one; all done → `/lode-release`.
