---
name: lode-go
description: "Lodestar extension — write Go. Write a good Go instruction (objective / done criteria / acceptance method / constraints / execution strategy) to put the AI into a self-driving loop. Use when you're handing the dev plan to the AI to run automatically, or any step lacks a clear Go. Trigger: /lode-go"
---

# Go Creator (Write Go)

Extension skill. **Go is the entry point of the whole loop**: all the standards and rules set earlier are ultimately handed to the AI via one Go, and the AI loops until the Go is achieved.

> Why a dedicated skill? Because most people write Go badly — vague objective, unverifiable standards — so either the AI drifts, or it thinks it's done when it isn't. **Writing a good Go is harder than writing code.** And the one best at writing Go is the AI itself: it's on the scene, knows where the conversation got to, the project's state, what comes next. Let it write the Go for you from context; you just glance and hit send.

## Usage (when to use)

- The dev plan is ready, and you're handing one Face (or all Faces) to the AI to self-drive.
- Any step lacks an executable, acceptance-testable Go.

## Done (a Go has five sections)

1. **Objective**: what to accomplish (one-line deliverable, e.g. "finish DEV-PLAN Phase 1").
2. **Done criteria**: what counts as done — program-judgeable (build with zero errors / all tests pass / review passes), listed item by item.
3. **Acceptance method**: how to verify — checkable evidence (key command output / test results / list of created-modified files / review report).
4. **Constraints**: what not to touch (e.g. don't change Product-Spec/Design-Brief, don't move the settled UI, **no push, don't delete prototype files**, unless the user confirms). Note: a **local commit** after each Face passes review **is allowed** (as a rollback point); the constraint is on irreversible outward-facing actions (push/store submission).
5. **Execution strategy**: goal-oriented — when one path is blocked, try multiple methods before stopping; keep pushing long tasks.

## Surface assumptions (mandatory before generating the Go)

Before handing the Go to the AI to self-drive, list your key assumptions about **objective/scope/acceptance** for the user to confirm at a glance — in a self-driving loop, a wrong assumption compounds exponentially and surfaces only after a long run:

```
I'm setting this Go on these assumptions; correct them now if wrong:
1. The objective scope stops at <Face N / Phase N>
2. <tech/data/dependency> stays as-is, unchanged
3. Acceptance is judged by <verify.sh all green + review passed>
→ If you don't correct it, send to execute.
```

## Three execution modes (paired with lode-plan / lode-build)

1. The main agent uses `lode-build` directly to run the whole plan.
2. Write **the first Face** as a Go, copy and execute, loop forward (most common).
3. Plan **all Faces holistically** and write **one Go** to develop it all in one pass (most efficient once practiced).

## Guardrails (red lines)

- Done criteria can't be "close enough / looks fine"; not judgeable = no standard.
- Go defines the finish line, not the implementation steps.
- A popup/draft, once written, usually needs no second edit, unless there's a special goal to add.
