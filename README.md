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

## The 13 skills (six mainline + seven extensions)

> Command = skill name (in Claude Code the slash command is the skill name; the model also auto-triggers by description).

Mainline (`①→⑥`):

| # | Command (= skill name) | What it does | Output |
|---|---|---|---|
| 1 | `/lode-spec` | **Interrogate** a fuzzy idea into a buildable requirement; at the start, get the current-state map ready (when changing existing code → delta) | `product-spec.md` + `system-map.md` |
| 2 | `/lode-brief` | Translate "feel" into concrete design decisions (optional) | `design-brief.md` |
| 3 | `/lode-design` | Produce high-fidelity design / clickable prototype (optional) | `mockups/` |
| 4 | `/lode-plan` | Split into Faces (when changing existing code: impact analysis/migration/baseline) | `dev-plan.md` |
| 5 | `/lode-build` | Build per the plan, running the four-step audit loop | code + `changelog.md` |
| 6 | `/lode-release` | Privacy audit + package & release (team: PR/CI) | Release |

> "Codebase recon" (reading existing code into `system-map.md`) is folded into `lode-spec`'s start — it's no longer a separate command; for a large/unfamiliar codebase, spec spawns the `lode-recon` **subagent** (see `agents/lode-recon.md`) to read it with a clean brain. `system-map.md` is a living map every project has, created by spec and kept current by build.

Extensions (as needed):

| Command (= skill name) | Use |
|---|---|
| `/lode-drive` | **Autonomous driver**: give one goal, the agent splits milestones→Faces and runs to the end; resumable, auditable ledger |
| `/lode-go` | Write a good **Go** (goal/standards/acceptance/constraints/execution strategy) |
| `/lode-review` | Fan out a subagent that **didn't write the code** for independent review (incl. regression/security/traceability) |
| `/lode-fix` | Reproduce → locate → minimal fix → regression |
| `/lode-skill` | Build a new skill: grant full capability, don't shred into tools |
| `/lode-evolve` | Distill real failures into rules (self-evolution engine) |
| `/lode-init` | Project init (**optional manual escape hatch**): normally provisioned automatically by spec/build; this command is just for manual pre-scaffold / repair |

---

## Install

> Prereq: [Claude Code](https://claude.com/claude-code). **Prefer the plugin (Method 1)** — install once, then just `/lode-spec` in any project; everything else is automatic. **Script install (Method 2)** is a fallback for when the plugin system isn't available.

### Method 1: plugin install (recommended)

```bash
/plugin marketplace add Leejaywell/lode-skills-en
/plugin install lodestar@lodestar
```
> Update: `/plugin marketplace update`. Uninstall: `/plugin uninstall lodestar@lodestar`.

**After install just use it — you never decide when any script gets installed:**

- Commands are namespaced as `/lodestar:lode-spec`, `/lodestar:lode-plan`, `/lodestar:lode-go`… (the model also auto-triggers by description); the `lode-review`, `lode-evolve`, and `lode-recon` subagents come along too.
- **The gate is always-on via the plugin** — no manual merge, nothing to "enable"; it exit-passes when there's no `.lode/` workspace, so leaving it on globally has no side effect.
- **Per-project files are provisioned by the flow at the right moment**: `CLAUDE.md` (the rules) is dropped by `lode-spec` the moment you enter a project; `verify.sh` is written by `lode-build` with real commands when development starts. **You just type `/lode-spec`.** (To pre-scaffold by hand: the optional `/lodestar:lode-init` — rarely needed.)

### Method 2: script install (fallback: environments without the plugin system)

No clone needed — one line installs into `~/.claude/`:
```bash
curl -fsSL https://raw.githubusercontent.com/Leejaywell/lode-skills-en/main/install.sh | bash
```
> Inspect before running: `curl -fsSL <same URL> -o /tmp/lode.sh && bash /tmp/lode.sh`. `CLAUDE_HOME=/path` overrides the install target.

Installs `skills/lode-*` and `agents/lode-*` (commands are the **bare** `/lode-spec`…), and the gate scripts into `~/.claude/lode-hooks/`. `CLAUDE.md`/`verify.sh` are still auto-provisioned by the flow. **The one manual step** (there's no plugin to wire the gate): merge the `hooks` block from `hooks/settings.json` into the project's `.claude/settings.json` (scripts resolve `$CLAUDE_PROJECT_DIR/hooks/`; first `cp -R ~/.claude/lode-hooks/. ./hooks && chmod +x ./hooks/*.sh`). If that's a hassle, use Method 1.

---

## How to use

### A. Autonomous (recommended) — one goal, the agent runs it to the end

```
/lode-drive Finish <goal>
```
`lode-drive` decides **from scratch/changing existing code** and **solo/team** itself, splits milestones→Faces, runs each through the four-step audit + regression, maintains a progress ledger (resumable after a crash, auditable when done), re-plans on drift and trips the breaker when stuck. You show up only to **review the PR** and **handle the breaker**.

### B. Manual, step by step — when you want to drive each stage

From scratch minimal loop:
```
/lode-spec    # interrogate requirements → product-spec.md
/lode-plan    # split into Faces (each Face's acceptance scenarios first) → dev-plan.md
/lode-go      # generate one Face's Go, paste & run it → four-step audit loop
```

- **Changing existing code**: still just `/lode-spec` — at the start it gets `system-map.md` ready automatically (reads the existing map for a project you built; spawns the `lode-recon` subagent to read a large foreign repo), then runs as a delta (current→target + must-never-break). Nothing else to type first.
- Full chain: insert `/lode-brief` (+ optional `/lode-design`) before plan; finish with `/lode-release` (team: PR/CI).
- Three granularities for one Face: the main agent runs `lode-build` through the plan / write a Go per Face (most common) / one Go for the whole thing (most efficient once fluent).

---

## Scope + modes

The lean mainline is tuned for **one person · from scratch · the first version**; two switches extend it to more complex situations (`lode-drive` detects them at the start — you don't set them by hand):

> Two project situations: **from scratch** = there's no code yet, you're building something new from zero; **changing existing code** = the project already has a codebase and you're modifying it or adding features.

- **From scratch ↔ changing existing code**: when changing existing code, spec at the start maps the current state automatically (spawning the `lode-recon` subagent for a large repo), the requirement is written as "what to change" (a delta), plan does impact analysis/migration/baseline, and verify runs a **full regression** (re-test what already worked so you don't break it).
- **One person ↔ team**: solo uses the local `review-passed` gate; multi-person/long-lived projects switch to the **PR/CI gate**, where the subagent review becomes a pre-PR filter (not a replacement for human review).
- **Safety/compliance**: plus mandatory security review + one-to-one requirement-code-test traceability.

Building from scratch takes the leanest flow; only when you're changing existing code or working in a team do the heavier guardrails kick in. **Autonomous ≠ unattended**: even with `lode-drive` running on its own, you still show up at "review the PR" and "catch the breaker."

---

## Design principles: three iron rules

1. **Give capabilities, not a pile of tools** — don't shatter one ability into a heap of special-purpose micro-tools; that's clumsier. Grant the full general capability and let the model compose it. The model's intelligence is **released, not designed**.
2. **Don't write a rule before hitting the wall** — every rule must trace to a real failure; if deleting it would let the problem recur, it earns its place. Don't write rules for pitfalls you haven't hit; delete the useless ones.
3. **Spend the effort on design, not on whistles** — stop tweaking prompts; what's worth money is designing the flow and the loop well (what each stage outputs, what counts as passing, what to do on a pitfall, how to evolve), and leave the rest to the AI.

### How it maps onto Claude Code

| Concept | Claude Code mechanism | Location in this repo |
|---|---|---|
| 13 skills | `SKILL.md` skills | `skills/lode-*` |
| Top-level rules | `CLAUDE.md` | `CLAUDE.md` |
| Independent subagents (review / recon / evolve) | `Agent` tool + subagent | `agents/lode-{review,recon,evolve}.md` |
| Deterministic rules → gate | **Hooks** (plugin `hooks/hooks.json` / project `.claude/settings.json`) | `hooks/` |
| Self-evolution (signals→proposals→rule base) | `CLAUDE.md` rule base + `lode-evolve` | `CLAUDE.md` + `skills/lode-evolve` |
| Doc-driven | runtime artifacts | `.lode/` (`system-map → product-spec → design-brief → dev-plan → code → changelog`) |
| Go = goal+standards+acceptance+constraints+execution | structured Go instruction | `skills/lode-go` |
