---
name: lode-order
description: "Lodestar extension — write an execution order. Write a good order (objective / done criteria / acceptance method / constraints / execution strategy) to put the AI into a self-driving loop. Use when you're handing the dev plan to the AI to run automatically, or any step lacks a clear order. Trigger: /lode-order"
---

# Order (write an execution order)

Extension skill. **The order is the entry point of the whole loop**: all the standards and rules set earlier are ultimately handed to the AI via one order, and the AI loops until the order is achieved.

> Why a dedicated skill? Because most people write orders badly — vague objective, unverifiable standards — so either the AI drifts, or it thinks it's done when it isn't. **Writing a good order is harder than writing code.** And the one best at writing orders is the AI itself: it's on the scene, knows where the conversation got to, the project's state, what comes next. Let it write the order for you from context; you just glance and hit send.

## Usage (when to use)

- The dev plan is ready, and you're handing one slice (or all slices) to the AI to self-drive.
- Any step lacks an executable, acceptance-testable order.

## Done (an order has five sections)

1. **Objective**: what to accomplish (one-line deliverable, e.g. "finish dev-plan Phase 1").
2. **Done criteria**: what counts as done — program-judgeable (build with zero errors / all tests pass / review passes), listed item by item.
3. **Acceptance method**: how to verify — checkable evidence (key command output / test results / list of created-modified files / review report).
4. **Constraints**: what not to touch (e.g. don't change spec/design-brief, don't move the settled UI, **no push, don't delete prototype files**, unless the user confirms). Note: a **local commit** after each slice passes review **is allowed** (as a rollback point); the constraint is on irreversible outward-facing actions (push/store submission).
5. **Execution strategy + circuit breaker**: goal-oriented — when one path is blocked, try multiple methods before stopping; keep pushing long tasks — **but set a breaker: stop and ask the human after ≥3 consecutive failures on the same slice or a token-budget overrun; don't retry forever**.

## Surface assumptions (mandatory before generating the order)

Before handing the order to the AI to self-drive, list your key assumptions about **objective/scope/acceptance** for the user to confirm at a glance — in a self-driving loop, a wrong assumption compounds exponentially and surfaces only after a long run:

```
I'm setting this order on these assumptions; correct them now if wrong:
1. The objective scope stops at <slice N / Phase N>
2. <tech/data/dependency> stays as-is, unchanged
3. Acceptance is judged by <verify.sh all green + review passed>
→ If you don't correct it, send to execute.
```

## Three execution modes (paired with lode-plan / lode-build)

1. The main agent uses `lode-build` directly to run the whole plan.
2. Write **the first slice** as an order, copy and execute, loop forward (most common).
3. Plan **all slices holistically** and write **one order** to develop it all in one pass (most efficient once practiced).

## Guardrails (red lines)

- Done criteria can't be "close enough / looks fine"; not judgeable = no standard.
- The order defines the finish line, not the implementation steps.
- An order, once written, usually needs no second pass before you send it — unless the goal calls for something extra.
- **An order is a fire-and-forget message, not persisted to disk**: its content is a re-rendering of that slice in the plan, and nothing downstream reads it; the trace of "what was issued / done" lives in `changelog.md` + `ledger.jsonl` + git — don't create a write-only archive nobody reads.

## → Next
Send the order → the AI self-drives that slice; once it passes the four-step audit + gate, write the next one or hand off to `/lode-auto`.
