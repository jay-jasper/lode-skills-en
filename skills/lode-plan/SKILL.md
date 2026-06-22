---
name: lode-plan
description: "Lodestar mainline ④ — development plan. Break the spec/design into a set of slices — each independently acceptance-testable and runnable. Use when you need to turn requirements into a dev plan, slice the work into tasks, and set each slice's acceptance criteria. Trigger: /lode-plan"
---

# Dev Planner (Development Plan)

Mainline step ④. Break `docs/spec.md` (and design artifacts) into a set of **slices**.

> **slice** = a **vertical, acceptance-testable slice**: once done it compiles, runs, and can be accepted on its own — not a horizontal "write all the models first, then all the UI."

## Usage (when to use)

- `docs/spec.md` (optionally `design-brief.md` / `mockups/`) is confirmed, ready to start.
- You need to turn "what to build" into "in what order, in how many slices."
- Before entering `lode-build`, there must be a plan.

## Done (what counts as acceptable)

Produce `.lode/dev-plan.md` (covering current-doc-status notes, tech-selection conclusions, slice planning with order/parallelizability tags, and any necessary database design and dev rules), satisfying:
- Broken into an ordered slice list, each slice a runnable vertical slice.
- **Each slice carries its own Goal**: objective / done criteria (program-judgeable) / acceptance method / **acceptance scenarios**.
- **Acceptance scenarios must be defined before building** (spec-bound): derive a few concrete, executable scenarios ("given X, do Y, get Z") from the spec's acceptance criteria — they dictate **what the tests must test**. This binds tests to the **requirement**, not to weak tests the builder reverse-engineers after writing the code — closing the "green tests but wrong feature" gap.
- Inter-slice dependencies marked; independent ones tagged **parallelizable** (for the main agent to decide whether to fan out subagents).
- Tech selection and key architecture decisions have brief notes and rationale.
- The first slice is the "thinnest runnable" skeleton, validating the loop works as early as possible.
- Define this project's **deterministic verification command** (build + test), for lode-build to land as `.lode/verify.sh` and the Stop gate to actually run — moving "did build/test pass" out of model self-assessment and into a program.
- **Seed the task board**: once the slices are set, write the slice list into the **native todo list** (one item per slice) as the starting point of the live progress board for build / auto — so the user sees "how many slices" right in the UI.

## Changing existing code extra (when changing an existing project, mandatory per change-slice)

Reading `system-map.md` + the spec's delta, add to each change-slice:
- **Blast radius**: which files/modules this slice touches and who calls it (determined via codegraph/call relations, not guesswork).
- **Regression surface**: which existing behaviors it ripples into; the corresponding existing-test scope to run (feeds the full-regression gate).
- **Baseline / pin behavior**: before touching anything, **actually run the existing tests and save a baseline**; for the area you're changing that has no tests, first add **characterization tests** to pin current behavior, then change.
- **Migration strategy**: for schema/interface/data-format changes, use **expand → migrate → contract** (coexist compatibly first, migrate, then seal up) — don't cut over in one shot.
- **Allow cross-slice refactor**: if an earlier slice's design turns out wrong, open a dedicated "refactor slice" to fix it — provided the regression net backstops it — rather than piling on top of a wrong design.

## Guardrails (red lines)

- Don't shred into a pile of fragmented tool/function tasks — grant capability, give acceptance-testable slices, let the Builder organize the implementation itself.
- Each slice's done criteria must be program-judgeable, not "close enough."
- The plan serves the loop; don't aim to freeze it perfectly in one shot — allow coming back to adjust during Build.
- If design prototype code already exists, the plan must explicitly **build directly on it and reuse the code**, not "for reference only" rewrite.
- Get the user's sign-off on the plan before entering `lode-build`.

## → Next
Plan set → build the first slice: `/lode-build` to run the plan, or `/lode-order` for one slice.
