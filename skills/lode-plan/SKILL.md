---
name: lode-plan
description: "Lodestar mainline ④ — development plan. Break the Product-Spec/design into a set of Faces — each independently acceptance-testable and runnable. Use when you need to turn requirements into a dev plan, slice the work into tasks, and set each slice's acceptance criteria. Trigger: /lode-plan"
---

# Dev Planner (Development Plan)

Mainline step ④. Break `Product-Spec.md` (and design artifacts) into a set of **Faces** (the real-world VibCut project split into 13).

> **Face** = a **vertical, acceptance-testable slice**: once done it compiles, runs, and can be accepted on its own — not a horizontal "write all the models first, then all the UI."

## Usage (when to use)

- `Product-Spec.md` (optionally `Design-Brief.md` / `mockups/`) is confirmed, ready to start.
- You need to turn "what to build" into "in what order, in how many slices."
- Before entering `lode-build`, there must be a plan.

## Done (what counts as acceptable)

Produce `.lode/<project>/DEV-PLAN.md` (covering current-doc-status notes, tech-selection conclusions, Face planning with order/parallelizability tags, and any necessary database design and dev rules), satisfying:
- Broken into an ordered Face list, each Face a runnable vertical slice.
- **Each Face carries its own Goal**: objective / done criteria (program-judgeable) / acceptance method.
- Inter-Face dependencies marked; independent ones tagged **parallelizable** (for the main agent to decide whether to fan out subagents).
- Tech selection and key architecture decisions have brief notes and rationale.
- The first Face is the "thinnest runnable" skeleton, validating the loop works as early as possible.
- Define this project's **deterministic verification command** (build + test), for lode-build to land as `.lode/<project>/verify.sh` and the Stop gate to actually run — moving "did build/test pass" out of model self-assessment and into a program.

## Guardrails (red lines)

- Don't shred into a pile of fragmented tool/function tasks — grant capability, give acceptance-testable slices, let the Builder organize the implementation itself.
- Each Face's done criteria must be program-judgeable, not "close enough."
- The plan serves the loop; don't aim to freeze it perfectly in one shot — allow coming back to adjust during Build.
- If design prototype code already exists, the plan must explicitly **build directly on it and reuse the code**, not "for reference only" rewrite.
- Get the user's sign-off on the plan before entering `lode-build`.
