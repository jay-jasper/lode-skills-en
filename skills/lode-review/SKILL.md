---
name: lode-review
description: "Lodestar extension — code review. Fan out a clean-head independent subagent to review a just-finished Face/change, as the completion gate. Use when a Face passes self-test and is ready to wrap up, or a quality gate is needed before release. Trigger: /lode-review"
---

# Code Reviewer

Extension skill · completion gate. This is the paradigm's **canonical case for fanning out a subagent** — the reviewer is freshly dispatched, didn't take part in development, has none of that "I wrote this code" bias, which is exactly why it reviews accurately.

## Usage (when to use)

- A Face passes self-test in `lode-build` and is ready to wrap up.
- The quality gate before release (`lode-release`).
- A mandatory gate before anything is marked "done."

## How to run it (orchestration)

The main agent **fans out a clean-head subagent**: use the `Agent` tool to invoke the `lode-review` subagent (see `agents/lode-review.md`), carrying **the full relevant context** (the change diff, that Face's Go, Product-Spec/DEV-PLAN excerpts). The subagent returns only a conclusion; **the main agent merges and decides**.

## Done (what counts as acceptable)

Return a structured review report covering the **four-step audit**: build verification, test completeness (unit + e2e + UI-click; for web projects incl. a11y/responsive/key-page performance), Code Review, functional test.
- The first two are deterministic, backstopped by the Stop gate's `verify.sh` actually running; the subagent just re-checks the exit code, and focuses its weight on the latter two judgment steps.
- Each issue graded by severity: CRITICAL / HIGH / MEDIUM / LOW.
- A clear verdict: **pass / fail** (any CRITICAL = fail).
- On pass, the **main agent** writes the conclusion into `.lode/<project>/REVIEW_PASSED` (note the reviewed Face/commit); the gate lets it through on that basis.
- On fail, each blocking item states "why + how to fix"; the main agent fixes and runs another round until Pass.

## Guardrails (red lines)

- The review subagent **reviews only, doesn't change code**; fixes go back to `lode-build` / `lode-fix`.
- Review not passed → wrap-up not allowed (enforced by the Stop hook gate, not by good intentions).
- Review scope aligns to the Go and Product-Spec; don't expand the requirement under cover of review.
- Decision authority stays with the main agent / human; the subagent doesn't decide the release for you.
