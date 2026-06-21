# DEV PLAN — <project name>

> Produced by lode-plan. Lands at `.lode/<project>/DEV-PLAN.md`
> Face = a vertical acceptance-testable slice: once done it compiles, runs, and can be accepted on its own.

## Tech Selection & Key Decisions
- Stack:
- Key decisions + rationale:

## Deterministic Verification (land as `.lode/<project>/verify.sh`)
> Wrap this project's "build + test" into one script, all pass → `exit 0`. The Stop gate actually runs it, moving build/test out of model self-assessment and into a program.
- Build command: <e.g. `npm run build`>
- Test command: <e.g. `npm test`>
- One-line combined command: <e.g. `npm run build && npm test`>

## Face List (ordered)

### Face 1 — <thinnest runnable skeleton>
- **Objective**:
- **Done criteria** (program-judgeable): build passes / zero errors / tests pass
- **Acceptance method**: commit log + test results + review report
- **Depends on**: none
- **Parallelizable**: no

### Face 2 — <…>
- **Objective**:
- **Done criteria**:
- **Acceptance method**:
- **Depends on**: Face 1
- **Parallelizable**: independent of Face 3 → parallelizable

## Dependency Graph (brief)
Face1 → Face2 ↘
Face1 → Face3 ↗  (Face2/3 parallelizable)
