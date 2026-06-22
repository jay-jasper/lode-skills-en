# Lodestar — Claude Code Edition

[中文](https://github.com/Leejaywell/lode-skills) · **English**

Lodestar is a structured development workflow that runs on Claude Code. It splits a fuzzy idea into five independently-verifiable stages: **requirements → design → plan → build → release**.

It doesn't promise to make your product good — what it guarantees is: every stage has an explicit "what counts as done"; the deterministic part (build/test) is hard-blocked by a program — fail it and you can't wrap up; the uncertain part (requirements, review) is pinned down until it's clear.

The whole method is three things:

- **Deterministic judgments go to a program (a hook — Claude Code's hook script)**: build/test fail → wrap-up is blocked; the gate doesn't just trust the model's "should be fine."
- **Review goes to a subagent that didn't write the code**: only a clean brain reviews accurately.
- **Rules grow from real failures**: write a rule only after hitting the wall; delete the ones that don't earn their place — rules may only get leaner, never pile up.

---

## The five stages

```
requirements ─→ design ─→ plan ──→ build ───→ release
pin down     translate  split    each slice  privacy audit
what to build   to concrete into     runs the  + package
                decisions  slices     4-step audit
                (optional)
```

Each stage produces a doc (requirements in the git-tracked `docs/spec.md`, other working drafts under `.lode/`, gitignored by default), which feeds the next stage — the AI carries context across stages through these docs, not memory.

> **What's a slice**: an independent, separately acceptance-testable piece of work. The plan stage (`lode-plan`) splits the goal into slices; you build and accept them one at a time.

**The four-step audit** (every slice must run it, ordered "deterministic → judgment"): build verification → test completeness → code review → functional test. The first two are actually run by the gate; the last two go to a subagent / human. All four pass → Done.

> **Tests bound to requirements**: each slice's "acceptance scenarios" are defined in the plan stage **before building**; tests are written to the scenarios and review checks against them — closing the "green tests but wrong feature" gap.

---

## The 13 skills (six mainline + seven extensions)

> **You don't need to memorize this table** — day to day you only type `/lode-spec` or `/lode-auto`; the rest the framework calls / chains automatically when needed. The table is a reference for what each does.
> Command = skill name (the slash command is the skill name; the model also auto-triggers by description).

Mainline (`①→⑥`):

| # | Command (= skill name) | What it does | Output |
|---|---|---|---|
| 1 | `/lode-spec` | **Pin down** a fuzzy idea into a buildable requirement; at the start, get the current-state map ready (when changing existing code → delta = write only what changes) | `docs/spec.md` + `system-map.md` |
| 2 | `/lode-brief` | Translate "feel" into concrete design decisions (optional) | `design-brief.md` |
| 3 | `/lode-design` | Produce high-fidelity design / clickable prototype (optional) | `mockups/` |
| 4 | `/lode-plan` | Split into slices (when changing existing code: impact analysis/migration/baseline) | `dev-plan.md` |
| 5 | `/lode-build` | Build per the plan, running the four-step audit loop | code + `changelog.md` |
| 6 | `/lode-release` | Privacy audit + package & release (team: PR/CI) | Release |

> "Codebase recon" (reading existing code into `system-map.md`) is folded into `lode-spec`'s start — it's no longer a separate command; for a large/unfamiliar codebase, spec spawns the `lode-recon` **subagent** (see `agents/lode-recon.md`) to read it with a clean brain. `system-map.md` is a living map every project has, created by spec and kept current by build.

Extensions (as needed):

| Command (= skill name) | Use |
|---|---|
| `/lode-auto` | **Autopilot**: give one goal, the agent splits milestones→slices and runs to the end; resumable, auditable ledger |
| `/lode-order` | Write a good **order** (goal/standards/acceptance/constraints/execution strategy) |
| `/lode-review` | Fan out a subagent that **didn't write the code** for independent review (incl. regression/security/traceability) |
| `/lode-fix` | Reproduce → locate → minimal fix → regression |
| `/lode-skill` | Build a new skill: grant full capability, don't shred into tools |
| `/lode-evolve` | Distill real failures into rules (self-evolution engine) |
| `/lode-init` | Project init (**optional manual escape hatch**): normally provisioned automatically by spec/build; this command is just for manual pre-scaffold / repair |

---

## Install

Prereq: [Claude Code](https://claude.com/claude-code).

**Plugin (recommended)** — two lines in Claude Code:
```bash
/plugin marketplace add Leejaywell/lode-skills-en
/plugin install lodestar@lodestar
```
Then just use it. Rules, the gate, and `verify.sh` are all auto-provisioned by the flow — **you configure nothing**.

**Script (when the plugin system isn't available)** — one line, same result, just bare `/lode-spec` (no `/lodestar:` prefix):
```bash
curl -fsSL https://raw.githubusercontent.com/Leejaywell/lode-skills-en/main/install.sh | bash
```

**Uninstall**: plugin `/plugin uninstall lodestar@lodestar`; script `bash ~/.claude/lode-uninstall.sh`. Your project's `.lode/` artifacts are kept by default.

> Details (how the gate is wired, where files go, `LODE_NO_HOOKS` / `--purge-project`) are printed by `install.sh` when it runs.

---

## How to use

**Day to day you only type 1 command** — the rest the framework calls / chains when needed, nothing to memorize:

| What you want | Type this |
|---|---|
| Give a goal, **fully autonomous** (recommended) | `/lode-auto Finish <goal>` |
| Drive it yourself, starting from requirements | `/lode-spec` |
| Add a feature / change old code | still `/lode-spec` (it maps the current state at the start) |
| Fix a bug | `/lode-fix` |

### Fully autonomous: `/lode-auto`
Give one goal; it decides from-scratch/changing-existing-code and solo/team, splits milestones→slices, runs each through the four-step audit + regression, keeps a progress ledger (resumable after a crash), re-plans on drift and trips the breaker when stuck (stops and hands back to you on repeated failure / budget overrun). You show up only to **review the PR** and **handle the breaker**.

### Manual, step by step — when you want to drive each stage
```
/lode-spec    # pin down requirements → docs/spec.md
/lode-plan    # split into slices (each slice's acceptance scenarios first) → dev-plan.md
/lode-order   # write one slice's order, hand it to the AI → four-step audit loop
```
- Want mockups? insert `/lode-brief` (+ optional `/lode-design`) before plan; finish with `/lode-release`.
- **The rest (recon / review / init…) the framework calls when it's time — you don't invoke them by hand.**

---

## Scope + modes

The lean mainline is tuned for **one person · from scratch · the first version**; two switches extend it to more complex situations (`lode-auto` detects them at the start — you don't set them by hand):

> Two project situations: **from scratch** = there's no code yet, you're building something new from zero; **changing existing code** = the project already has a codebase and you're modifying it or adding features.

- **From scratch ↔ changing existing code**: when changing existing code, spec at the start maps the current state automatically (spawning the `lode-recon` subagent for a large repo), the requirement is written as "what to change" (a delta), plan does impact analysis/migration/baseline, and verify runs a **full regression** (re-test what already worked so you don't break it).
- **One person ↔ team**: solo uses the local `review-passed` gate; multi-person/long-lived projects switch to the **PR/CI gate**, where the subagent review becomes a pre-PR filter (not a replacement for human review).
- **Safety/compliance**: plus mandatory security review + one-to-one requirement-code-test traceability.

Building from scratch takes the leanest flow; only when you're changing existing code or working in a team do the heavier guardrails kick in. **Autonomous ≠ unattended**: even with `lode-auto` running on its own, you still show up at "review the PR" and "catch the breaker."

> **Small tasks stay light**: for a ten-line change or a config tweak, a one-sentence spec, a single slice, and skipping design are all fine — the gate only bites once dev has started. Full guardrails are for big work / brownfield / teams.

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
| Self-evolution (signals→proposals→rule base) | `CLAUDE.md` rule base + `lode-evolve` (auto-prompted at session start) | `CLAUDE.md` + `skills/lode-evolve` |
| Doc-driven | deliverable docs + runtime | `docs/spec*` (git-tracked) + `.lode/` (gitignored: `system-map / design-brief / dev-plan / changelog …`) |
| order = goal+standards+acceptance+constraints+execution | structured order instruction | `skills/lode-order` |
