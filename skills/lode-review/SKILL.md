---
name: lode-review
description: "Lodestar extension — code review. Fan out a clean-head independent subagent to review a just-finished slice/change, as the completion gate. Use when a slice passes self-test and is ready to wrap up, or a quality gate is needed before release. Trigger: /lode-review"
---

# Code Reviewer

Extension skill · completion gate. This is the paradigm's **canonical case for fanning out a subagent** — the reviewer is freshly dispatched, didn't take part in development, has none of that "I wrote this code" bias, which is exactly why it reviews accurately.

## Usage (when to use)

- A slice passes self-test in `lode-build` and is ready to wrap up.
- The quality gate before release (`lode-release`).
- A mandatory gate before anything is marked "done."

## How to run it (orchestration)

The main agent **fans out a clean-head subagent**: use the `Agent` tool to invoke the `lode-review` subagent (see `agents/lode-review.md`), carrying **the full relevant context** (the change diff, that slice's order, spec/dev-plan excerpts). The subagent returns only a conclusion; **the main agent merges and decides**.

## Done (what counts as acceptable)

Return a structured review report covering the **four-step audit**: build verification, test completeness (unit + e2e + UI-click; for web projects incl. a11y/responsive/key-page performance), Code Review, functional test.
- The first two are deterministic, backstopped by the Stop gate's `verify.sh` actually running; the subagent just re-checks the exit code, and focuses its weight on the latter two judgment steps.
- **Test completeness is checked spec-bound**: every "acceptance scenario" of this slice has a corresponding test, and the tests test the requirement, not the implementation; the functional test **runs each acceptance scenario** — "tests exist and are green" is not a pass.
- Each issue graded by severity: CRITICAL / HIGH / MEDIUM / LOW.
- A clear verdict: **pass / fail** (any CRITICAL = fail).
- On pass, the **main agent** writes the conclusion into `.lode/review-passed` (note the reviewed slice/commit, plus a line `tree: <current code fingerprint>` — get it via `lode-gate.sh fingerprint`). The gate lets it through on that basis, and verifies the fingerprint matches current code: **edit-after-review invalidates the marker and requires a re-review**.
- On fail, each blocking item states "why + how to fix"; the main agent fixes and runs another round until Pass.

**Changing existing code / team / safety-critical extra review:**
- **Regression**: the full existing suite has no new red; compared against the pre-change baseline to tell "broke it" from "already broken"; the spec's "must never break" list confirmed item by item.
- **Security/compliance**: when touching auth, user input, queries, files, external calls, crypto, or payments, run a mandatory security review (per OWASP); no hard-coded secrets.
- **Traceability**: requirement → code → test line up — every acceptance criterion has a corresponding test, every change traces back to a requirement (required for regulated systems).
- **Team mode**: this review is a **pre-PR filter**, not a substitute for human review; completion = PR passes CI + required approvals merged, and `review-passed` is only for local/solo mode.

## Guardrails (red lines)

- The review subagent **reviews only, doesn't change code**; fixes go back to `lode-build` / `lode-fix`.
- Review not passed → wrap-up not allowed (enforced by the Stop hook gate, not by good intentions).
- Review scope aligns to the order and spec; don't expand the requirement under cover of review.
- Decision authority stays with the main agent / human; the subagent doesn't decide the release for you.
