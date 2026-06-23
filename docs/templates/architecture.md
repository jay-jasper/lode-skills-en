# architecture — <project name>

> Built by lode-spec at the start, kept current by lode-build (a living current-state map every project has). Lands at `docs/architecture.md` — a **git-tracked deliverable**: it persists across cycles, reaches teammates/CI without a re-recon, and is meant for developers to review the system's current state (unlike `.lode/` working drafts, it is NOT wiped after release).
> Purpose: let spec know the current state, let plan do impact analysis, let build's changes "look like the existing code," and let a new teammate grasp the system at a glance.

## Architecture map
- Stack / framework / version:
- Modules / layers (+ each one's responsibility):
- Key entry points (main / routes / API / CLI):
- Data flow (the main path: request → processing → storage):
- External deps and integration points (DB / 3rd-party APIs / queues …):

## Conventions (later changes follow these to "look like the existing code")
- Naming / directory organization:
- Error handling / logging / configuration:
- Hard code-style constraints (program-judgeable → hand to lint/hook):

## How to run it (feed into verify.sh)
- Build: `<e.g. npm run build>`
- Test: `<e.g. npm test>`
- Run: `<e.g. npm run dev>`
- lint / typecheck: `<e.g. npm run lint>`

## Baseline snapshot (run once before changing anything)
- Test status: ✅ all green / ⚠️ N already red (list them: …)
- Coverage blind spots (high-risk areas; add characterization tests before changing these):
- Build status: ✅ / ❌ (explain)

## Hotspots & risk
- High coupling / giant files:
- Untested core paths:
- Security / data-sensitive surfaces:
- Areas this goal will touch (blast-radius estimate):
