# system-map — <project name>

> Built by lode-spec at the start, kept current by lode-build (a living current-state map every project has). Lands at `.lode/system-map.md`
> Purpose: let spec know the current state, let plan do impact analysis, let build's changes "look like the existing code."

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
