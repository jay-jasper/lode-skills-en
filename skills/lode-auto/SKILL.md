---
name: lode-auto
description: "Lodestar autopilot (autonomous run-to-completion). Take one goal and run the whole mainline autonomously: detect from scratch/changing existing code and solo/team mode → break into milestones and slices → run each through the four-step audit + regression → commit/open PR → update a progress ledger → replan on divergence → until the goal is met or the breaker trips. Use when the user 'sets one goal and wants the agent to run it to completion autonomously.' Trigger: /lode-auto"
---

# Autopilot

Lodestar's autonomous brain. This is what makes "one goal → run to completion → from scratch or changing existing code" real: it doesn't write a single order, it **runs the whole mainline loop on its own**, running to the end on a resumable **progress ledger**.

> Autonomous ≠ unattended. It drives the whole way; the human shows up at just two points: **reviewing PRs** and **handling the breaker**.

## Usage (when to use)

- The user gives one goal and wants the agent to **run the entire goal to completion autonomously**, without babysitting each step.
- The goal may span many slices / many Sessions, needing to survive crashes and be auditable when done.

## Set two modes at the start (they decide how heavy the guardrails are)

1. **From scratch ↔ changing existing code**: a pre-existing codebase means you are changing existing code → spec gets `system-map.md` ready at the start (spawn the `lode-recon` subagent for a large foreign repo), runs in delta mode, plan does impact analysis, verify runs **full regression**. From scratch uses the lean flow.
2. **Solo ↔ team**: solo uses the local `review-passed` gate; team/long-lived switches to the **PR/CI gate** — completion = PR passes CI + required approvals merged.

## How to run (the autopilot loop)

1. **Set the goal / pick up existing artifacts**: first check `.lode/<project>/` for existing artifacts — **if `product-spec.md` already exists (e.g. you ran `/lode-spec` first to pin the requirements down), use it as the input directly, reading in `design-brief.md` / `mockups/` / `system-map.md` along with it, and never re-gather requirements**; `goal.md` just records the goal + acceptance-testable done criteria and points at that spec. Only do a quick local spec pass when no spec exists (a sentence or two for a small goal).
2. **Decompose**: decompose **from `product-spec.md` (not the one-line goal)** → milestones → ordered slices (each slice a Goal, tagged with dependencies/parallelizability/blast-radius). Write into `dev-plan.md`.
3. **Open the ledger**: `.lode/<project>/ledger.jsonl`, one record per slice (status + commit/PR + time).
4. **Loop**: read the ledger → pick the next **unblocked** slice → do it with `lode-build` → **four-step audit + full regression** → commit (team mode: open PR, wait for CI/review) → **update the ledger** → next.
5. **Replan**: a slice reveals the plan was wrong → go back to `lode-plan`, fix the plan, then continue; **don't grind on a stale plan**.
6. **Circuit breaker**: ≥3 consecutive failures on the same slice, or a token-budget overrun → stop and ask the user, laying out the sticking point and what's known in one go.
7. **Wrap up**: all milestones met → run `lode-release` (or merge the final PR) → self-check against goal.md's done criteria.

## Done (what counts as acceptable)

- `goal.md` + `dev-plan.md` + `ledger.jsonl` all present and continuously updated; at any moment the ledger shows "where it's at, what's left."
- Every slice passed the four-step audit + regression gate (team mode: PR merged), faithfully recorded in the ledger.
- Goal met = every done criterion in `goal.md` satisfied, argued with evidence (command output/PRs/reviews).
- A mid-run crash can resume losslessly from the ledger; the whole run is auditable.

## Guardrails (red lines)

- **Pick up existing artifacts first**: if `.lode/<project>/` already has `product-spec.md`, read it and decompose from it — don't bypass it and reinvent requirements from a one-line goal; the requirements `/lode-spec` pinned down must not be lost here.
- **The ledger is the truth**: a status is written `passed` only after the four-step audit/regression/PR actually pass — no optimistic early marking.
- **Breaker over grinding**: the gate blocks "bad completion," the breaker blocks "expensive non-completion"; if stuck, stop, don't burn tokens.
- Changing existing code must have `system-map.md` (spec ensures it at the start; large repo → `lode-recon` subagent) and must run full regression; **no baseline, no touching old code**.
- In team mode, "completion" = merged, not a local marker; the subagent review is only a pre-PR filter, not a substitute for human review.
- One goal, one ledger; parallel slices don't touch the same file, the main agent merges conflicts.
- Decision authority always stays with the human: confirm before irreversible outward actions (push is covered by the PR flow; store submission/deploy).
