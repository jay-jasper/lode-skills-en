# DEV PLAN — <project name>

> Produced by lode-plan. Lands at `.lode/dev-plan.md`
> Slice = an independent, acceptance-testable vertical slice: once done it compiles, runs, and can be accepted on its own.

## Mode
- From scratch / changing existing code: <changing existing code needs a system-map.md first>
- Solo / team: <team uses the PR/CI gate>

## Tech Selection & Key Decisions
- Stack:
- Key decisions + rationale:

## Deterministic Verification (land as `.lode/verify.sh`)
> Wrap this project's "build + test" into one script, all pass → `exit 0`. The Stop gate actually runs it, moving build/test out of model self-assessment and into a program.
- Build command: <e.g. `npm run build`>
- Test command: <e.g. `npm test`>
- One-line combined command: <e.g. `npm run build && npm test`>

## Slice list (ordered)

### Slice 1 — <thinnest runnable skeleton>
- **Objective**:
- **Done criteria** (program-judgeable): build passes / zero errors / tests pass
- **Acceptance scenarios** (defined before building, derived from the spec's acceptance criteria): given <…> do <…> get <…>
- **Acceptance method**: commit log + test results + review report
- **Depends on**: none
- **Parallelizable**: no

### Slice 2 — <…>
- **Objective**:
- **Done criteria**:
- **Acceptance method**:
- **Depends on**: Slice 1
- **Parallelizable**: independent of Slice 3 → parallelizable
- **(changing existing code) Blast radius**: which files/modules it touches, who calls it
- **(changing existing code) Regression surface + migration**: existing behavior rippled / characterization baseline / expand→migrate→contract

## Dependency Graph (brief)
Face1 → Face2 ↘
Face1 → Face3 ↗  (Face2/3 parallelizable)
