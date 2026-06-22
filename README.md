# Lodestar — Claude Code Edition

[中文](https://github.com/Leejaywell/lode-skills) · **English**

Lodestar is a structured development workflow that runs on Claude Code. It splits a fuzzy idea into five independently-verifiable stages: **requirements → design → plan → build → release**.

It doesn't promise to make your product good — what it guarantees is: every stage has an explicit "what counts as done"; the deterministic part (build/test) is hard-blocked by a program — fail it and you can't wrap up; the uncertain part (requirements, review) is interrogated until it's clear.

The whole method is three things:

- **Deterministic judgments go to a hook**: build/test fail → wrap-up is blocked; the gate doesn't just trust the model's "should be fine."
- **Review goes to a subagent that didn't write the code**: only a clean brain reviews accurately.
- **Rules grow from real failures**: write a rule only after hitting the wall; delete the ones that don't earn their place — rules may only get leaner, never pile up.

---

## The five stages

```
requirements ─→ design ─→ plan ──→ build ───→ release
interrogate     translate  split    each Face  privacy audit
what to build   to concrete into     runs the  + package
                decisions  Faces     4-step audit
                (optional)
```

Each stage produces a doc under `.lode/<project>/`, which feeds the next stage — the AI carries context across stages through these docs, not memory.

**The four-step audit** (every Face must run it, ordered "deterministic → judgment"): build verification → test completeness → code review → functional test. The first two are actually run by the gate; the last two go to a subagent / human. All four pass → Done.

> **Tests bound to requirements**: each Face's "acceptance scenarios" are defined in the plan stage **before building**; tests are written to the scenarios and review checks against them — closing the "green tests but wrong feature" gap.

---

## The 14 skills (seven mainline + seven extensions)

> Command = skill name (in Claude Code the slash command is the skill name; the model also auto-triggers by description).

Mainline (`⓪→⑥`):

| # | Command (= skill name) | What it does | Output |
|---|---|---|---|
| 0 | `/lode-recon` | **(brownfield)** Map existing architecture/conventions/commands/baseline | `system-map.md` |
| 1 | `/lode-spec` | **Interrogate** a fuzzy idea into a buildable requirement (brownfield → delta) | `product-spec.md` |
| 2 | `/lode-brief` | Translate "feel" into concrete design decisions (optional) | `design-brief.md` |
| 3 | `/lode-design` | Produce high-fidelity design / clickable prototype (optional) | mockups/prototype |
| 4 | `/lode-plan` | Split into Faces (brownfield: impact analysis/migration/baseline) | `dev-plan.md` |
| 5 | `/lode-build` | Build per the plan, running the four-step audit loop | code + `changelog.md` |
| 6 | `/lode-release` | Privacy audit + package & release (team: PR/CI) | Release |

Extensions (as needed):

| Command (= skill name) | Use |
|---|---|
| `/lode-drive` | **Autonomous driver**: give one goal, the agent splits milestones→Faces and runs to the end; resumable, auditable ledger |
| `/lode-go` | Write a good **Go** (goal/standards/acceptance/constraints/execution strategy) |
| `/lode-review` | Fan out a subagent that **didn't write the code** for independent review (incl. regression/security/traceability) |
| `/lode-fix` | Reproduce → locate → minimal fix → regression |
| `/lode-skill` | Build a new skill: grant full capability, don't shred into tools |
| `/lode-evolve` | Distill real failures into rules (self-evolution engine) |
| `/lode-init` | Project init: one-shot scaffold of `CLAUDE.md` + `.lode/<project>/verify.sh` (use after a plugin install to start) |

---

## Install

> Prereq: [Claude Code](https://claude.com/claude-code). **Prefer the plugin** — update, uninstall, and gate wiring are all automatic; the plugin works from two sources: **GitHub** or a **local clone**. After install, run `/lode-init` once in your project to scaffold the per-project files. Script install is only a fallback for old environments.

### Plugin install (recommended)

**Source 1: GitHub (simplest)**
```bash
/plugin marketplace add Leejaywell/lode-skills-en
/plugin install lodestar@lodestar
```

**Source 2: local clone (offline / want to edit the source)**
```bash
git clone https://github.com/Leejaywell/lode-skills-en.git
# inside Claude Code:
/plugin marketplace add ./lode-skills-en
/plugin install lodestar@lodestar
```
> Update: `git pull` in the repo, then `/plugin marketplace update`. Uninstall: `/plugin uninstall lodestar@lodestar`.

**Both sources end up identical:**

- Commands are namespaced as `/lodestar:lode-spec`, `/lodestar:lode-plan`, `/lodestar:lode-go`… (the model also auto-triggers by description); the `lode-review` and `lode-evolve` subagents come along too.
- **The gate activates with the plugin** — no manual hooks merge; the gate scripts exit-pass when there's no `.lode/` workspace, so enabling it globally has no side effect.
- **Run `/lodestar:lode-init` once in the target project**: it scaffolds the top-level `CLAUDE.md` + a `.lode/<project>/verify.sh` skeleton (the two per-project files a plugin won't auto-deploy). Then `/lodestar:lode-spec` to start.

### Script install (fallback: environments without the plugin system)

```bash
git clone https://github.com/Leejaywell/lode-skills-en.git
cd lode-skills-en && bash install.sh
```
Copies `skills/lode-*` and `agents/lode-*` into `~/.claude/`; commands are the **bare** `/lode-spec`, `/lode-plan`… (project-only: copy `skills/` and `agents/` into the project's `.claude/`). A script install has no automatic plugin gate, so per project: ① merge the `hooks` block from `hooks/settings.json` into `.claude/settings.json` (scripts resolve `$CLAUDE_PROJECT_DIR/hooks/`, so `cp -R hooks ./` and `chmod +x` first); ② run `/lode-init` to scaffold `CLAUDE.md` + `verify.sh`.

---

## How to use

### A. Autonomous (recommended) — one goal, the agent runs it to the end

```
/lode-drive Finish <goal>
```
`lode-drive` decides **new/old project** and **solo/team** itself, splits milestones→Faces, runs each through the four-step audit + regression, maintains a progress ledger (resumable after a crash, auditable when done), re-plans on drift and trips the breaker when stuck. You show up only to **review the PR** and **handle the breaker**.

### B. Manual, step by step — when you want to drive each stage

Greenfield minimal loop:
```
/lode-spec    # interrogate requirements → product-spec.md
/lode-plan    # split into Faces (each Face's acceptance scenarios first) → dev-plan.md
/lode-go      # generate one Face's Go, paste & run it → four-step audit loop
```

- **Old project**: first `/lode-recon` → `system-map.md`, then spec runs as a delta automatically (current→target + must-never-break).
- Full chain: insert `/lode-brief` (+ optional `/lode-design`) before plan; finish with `/lode-release` (team: PR/CI).
- Three granularities for one Face: the main agent runs `lode-build` through the plan / write a Go per Face (most common) / one Go for the whole thing (most efficient once fluent).

---

## Scope + modes

The lean mainline is tuned for **solo · greenfield · 0→1**; two **mode switches** extend it to old projects and teams (`lode-drive` detects them at the start):

- **Greenfield ↔ brownfield**: old project first `/lode-recon` for a system map, spec runs as a delta, plan does impact analysis/migration/baseline, verify runs **full regression**.
- **Solo ↔ team**: solo uses the local `review-passed` gate; team/long-lived switches to the **PR/CI gate**, and the subagent review drops to a pre-PR filter (not a substitute for human review).
- **Safety/compliance**: plus mandatory security review + requirement-code-test traceability.

Greenfield stays light; old projects and teams get the heavy guardrails. **Autonomous ≠ unattended**: even running autonomously via `lode-drive`, the human still shows up at "review the PR" and "handle the breaker."

---

## Design principles: three iron rules

1. **Give capabilities, not a pile of tools** — don't shatter one ability into a heap of special-purpose micro-tools; that's clumsier. Grant the full general capability and let the model compose it. The model's intelligence is **released, not designed**.
2. **Don't write a rule before hitting the wall** — every rule must trace to a real failure; if deleting it would let the problem recur, it earns its place. Don't write rules for pitfalls you haven't hit; delete the useless ones.
3. **Spend the effort on design, not on whistles** — stop tweaking prompts; what's worth money is designing the flow and the loop well (what each stage outputs, what counts as passing, what to do on a pitfall, how to evolve), and leave the rest to the AI.

### How it maps onto Claude Code

| Concept | Claude Code mechanism | Location in this repo |
|---|---|---|
| 14 skills | `SKILL.md` skills | `skills/lode-*` |
| Top-level rules | `CLAUDE.md` | `CLAUDE.md` |
| Independent reviewer subagent | `Agent` tool + subagent | `agents/lode-review.md` |
| Deterministic rules → gate | **Hooks** (plugin `hooks/hooks.json` / project `.claude/settings.json`) | `hooks/` |
| Self-evolution (signals→proposals→rule base) | `CLAUDE.md` rule base + `lode-evolve` | `CLAUDE.md` + `skills/lode-evolve` |
| Doc-driven | runtime artifacts | `.lode/` (`product-spec → design-brief → dev-plan → code → changelog`) |
| Go = goal+standards+acceptance+constraints+execution | structured Go instruction | `skills/lode-go` |
