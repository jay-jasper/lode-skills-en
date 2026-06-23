---
name: lode-release
description: "Lodestar mainline ⑥ — build & release. Privacy audit + packaging + release, producing a deliverable release build. Use when all slices are done and review-passed and it's time to package/ship. Trigger: /lode-release"
---

# Release Builder

Mainline step ⑥. The wrap-up: **privacy audit → package → release**, producing a version deliverable to users.

## Usage (when to use)

- All in-plan slices are done and have passed `lode-review`.
- Ready to produce a distributable artifact (e.g. a Mac/Electron package, a deployable build).
- A final privacy/security gate is needed before shipping.

## Team / long-lived: PR/CI completion mode

In solo mode, "completion" = local build + `review-passed`. **Team / long-lived projects switch to VCS-native completion**:
- Open a **branch** per slice/Epic, atomic commits, open a **PR**.
- The subagent review (`lode-review`) runs first as a **pre-PR filter**;
- "Completion" = **PR passes CI + required approvals → merged to mainline**, not a local marker.
- Only after merge is the ledger updated to passed; the main agent resolves conflicts.
- This upgrades self-review to peer review and directly supports multi-person collaboration.

## Done (what counts as acceptable)

- **Privacy audit passes**: no hard-coded keys/tokens, no accidental collection/upload of user data, permission requests minimal and justified.
- Production build succeeds, producing a runnable artifact for the target platform.
- Release notes written (version number, change summary, known limitations), sourced from **`git log` since the last tag** (per-slice commits are the change stream; non-git projects fall back to `.lode/changelog.md`).
- **Clean up cycle drafts + disarm the gate**: after a successful release, record this cycle's gist as one line in `docs/spec-changelog.md`, then delete the `.lode/plan/` and `.lode/design/` directories, the `.lode/.building` arm marker, and `.lode/changelog.md` (if any) (they're cycle scaffolding, all historical versions included; durable tracking lives in `docs/spec-changelog.md` + `docs/architecture.md` + git; once `.building` is deleted the gate goes dormant and reactivates when the next cycle's first slice re-touches it).
- Acceptance/install instructions provided, so the user can get it running.
- **Actively demo it running**: after packaging/building, run it yourself and screenshot, or give a "install like this, run like this" command — let the user see the finished product running, not just hand over a package.
- **Team mode**: all PRs passed CI + approved and merged; the release is cut from mainline.
- Put the release steps (privacy audit → package → demo → ship) on the **native todo list**, ticking one at a time so the user sees the wrap-up progress.

## Guardrails (red lines)

- Review not passed, slices not all done → release not allowed (enforced by the gate).
- Privacy audit finds a CRITICAL issue → stop and fix immediately; don't ship sick.
- Don't sneak new features into the release step; only seal up and package.
- Confirm with the user before any release action (push / store submission / other irreversible outward-facing operation).

## → Next
Released. Team mode: real completion = PR passes CI + required approvals merged.
