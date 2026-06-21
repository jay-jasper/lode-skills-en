---
name: lode-release
description: "Lodestar mainline ⑥ — build & release. Privacy audit + packaging + release, producing a deliverable release build. Use when all Faces are done and review-passed and it's time to package/ship. Trigger: /lode-release"
---

# Release Builder

Mainline step ⑥. The wrap-up: **privacy audit → package → release**, producing a version deliverable to users.

## Usage (when to use)

- All in-plan Faces are done and have passed `lode-review`.
- Ready to produce a distributable artifact (e.g. a Mac/Electron package, a deployable build).
- A final privacy/security gate is needed before shipping.

## Done (what counts as acceptable)

- **Privacy audit passes**: no hard-coded keys/tokens, no accidental collection/upload of user data, permission requests minimal and justified.
- Production build succeeds, producing a runnable artifact for the target platform.
- Release notes written (version number, change summary, known limitations), sourced from `CHANGELOG.md`.
- Acceptance/install instructions provided, so the user can get it running.

## Guardrails (red lines)

- Review not passed, Faces not all done → release not allowed (enforced by the gate).
- Privacy audit finds a CRITICAL issue → stop and fix immediately; don't ship sick.
- Don't sneak new features into the release step; only seal up and package.
- Confirm with the user before any release action (push / store submission / other irreversible outward-facing operation).
