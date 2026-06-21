# Lodestar — Claude Code Edition

> **Lodestar** — a 1:1 port of CodeX's "Product Manager 5.0" development paradigm onto Claude Code's native capabilities, as a standalone development flow.
> In one line: **you set the star, the AI navigates.**
> (English edition. Translated from the Chinese original, which was verified line-by-line against the source video transcript + keyframes.)
>
> **Core belief**: Prompts are depreciating; process design is appreciating. AI is no longer a tool but the executor of the entire development process.
> **Humans set the goal, the AI runs the loop**: the human does only two things — **make decisions** and **accept results** — and even "setting the goal" can be ghost-written by the AI.
>
> Its positioning is a **product-development coach**: not just helping you write code, but breaking the whole development process into a clear flow that walks you through step by step — even if you've only just touched vibe coding, follow along and you'll ship something usable.

---

## Paradigm mapping: CodeX → Claude Code

| Paradigm concept | Claude Code native equivalent | Location in this repo |
|---|---|---|
| 11 Skills (`.agents/skills/`) | `SKILL.md` skills | `skills/lode-*` |
| Top-level rules `AGENTS.md` (root) | Top-level rules `CLAUDE.md` | `CLAUDE.md` |
| Subagents (`.codex/agents/`) | `Agent` tool + subagents | `agents/lode-review.md` |
| `hooks.json` (deterministic rules → gate) | **Hooks** (`.claude/settings.json`) | `hooks/` |
| Self-evolution (signals→proposals→rule base) | `CLAUDE.md` rule base + Evolution Runner | `CLAUDE.md` + `skills/lode-evolve` |
| Skill writes only Usage/Done/Guardrails | Skill frontmatter + minimal body | each `SKILL.md` |
| Doc-driven (Product-Spec→Brief→Plan→Code→Changelog) | in-repo artifacts | `.lode/` runtime artifacts |
| Go = goal+standards+acceptance+constraints+execution strategy | structured Go instruction | `skills/lode-go` |

> Install layout: the original paradigm puts the 11 skills under `.agents/skills/`, subagents/hooks/evolution rules under `.codex/`, and the top-level `AGENTS.md` at the root.
> Claude Code equivalent: skills go in `~/.claude/skills/` (or project `.claude/skills/`), subagents in `.claude/agents/`, hooks in `.claude/settings.json`, top-level rules in `CLAUDE.md`.

---

## The 11 skills (six mainline + five extensions)

> Command = skill name (in Claude Code the slash command is the skill name; the model also auto-triggers by description).

Mainline (`①→⑥`):

| # | Command (= skill name) | What it does | Output |
|---|---|---|---|
| 1 | `/lode-spec` | **Interrogate** a fuzzy idea into a buildable requirement (blunt, no flattery) | `Product-Spec.md` |
| 2 | `/lode-brief` | Translate "feel" into concrete design decisions (optional) | `Design-Brief.md` |
| 3 | `/lode-design` | Produce high-fidelity design / clickable prototype (optional) | mockups/prototype |
| 4 | `/lode-plan` | Split into Faces, each independently acceptance-testable and runnable | `DEV-PLAN.md` |
| 5 | `/lode-build` | Build per the plan, running the four-step audit loop | code + `CHANGELOG.md` |
| 6 | `/lode-release` | Privacy audit + package & release | Release |

Extensions (as needed):

| Command (= skill name) | Use |
|---|---|
| `/lode-go` | Write a good **Go** (goal/standards/acceptance/constraints/execution strategy); the AI writes it most accurately |
| `/lode-review` | Fan out a **clean-brain** subagent for independent review (completion gate) |
| `/lode-fix` | Reproduce → locate → minimal fix → regression |
| `/lode-skill` | Build a new skill: grant full capability, don't shred into tools |
| `/lode-evolve` | Distill real failures into rules (self-evolution engine) |

---

## How to use

**Go is the entry point of the loop.** All the standards and rules set earlier are ultimately handed to the AI via one `Go`. There are three ways to execute the dev plan:

1. **DevBuilder**: the main agent uses `lode-build` directly to write code and run the whole plan.
2. **One Go at a time (most common)**: `lode-go` writes the first Face as a Go; copy and send it to execute, looping to completion.
3. **One Go for everything (most efficient, once practiced)**: have `lode-go` plan all Faces holistically into one Go and develop it all in one pass.

Minimal loop:
```
/lode-spec    # interrogate requirements → Product-Spec.md
/lode-plan    # split into Faces → DEV-PLAN.md
/lode-go      # generate the Go
# copy the Go, send to the AI to execute → auto-development + four-step audit loop
```
Full chain: before spec you can run `/lode-go` to turn a one-line idea into a Go; before plan insert `/lode-brief` (+ optional `/lode-design`); wrap up with `/lode-release`.

### Gate & hooks (deterministic judgments → a program)

Merge `hooks/` (`lode-gate.sh` + `lode-signal.sh` + the hooks block in `settings.json`) into the project's `.claude/settings.json`:

- **Stop gate `lode-gate.sh`**: before wrapping up a workspace where dev has started, ① actually run `.lode/<project>/verify.sh` (build+test, verdict by exit code) ② check the non-empty `REVIEW_PASSED` marker no older than CHANGELOG. **Build/test are actually run by a program, not trusting only the model-written flag.**
- **UserPromptSubmit hook `lode-signal.sh`**: on a correction/dissatisfaction keyword, auto-append the signal to `signals.jsonl` to feed self-evolution.
- Before the first Face, lay down a project-level `verify.sh` per `docs/templates/verify.sh` (wrapping this project's build+test commands).

---

## Three iron rules (the author's battle lessons)

1. **Build fewer tools, grant more capability** — defining a dozen little editing tools for VibCut made it hopelessly dumb; tearing it down and granting the full general capability so it figured things out itself brought it to life. The model's smartness is **released, not designed**.
2. **Don't pre-write rules; set them after hitting the pitfall** — a rule must correspond to one real failure; if deleting it makes the problem recur, it earns its place. Don't set rules for pitfalls you haven't hit; proactively delete the useless ones.
3. **Spend your effort on design, not on whistle-blowing** — stop fiddling with prompts; what's truly valuable is designing the flow and the loop well (what each step produces, what counts as passing, what to do on a pitfall, how to evolve), and leave the rest for the AI to decide.

> Real-world reference **VibCut** (a video-editing agent, Mac/Electron): 0 lines of hand-written code, fully AI-autonomous throughout, ~2h45m, ~2.85M tokens, split into 13 Faces; the author iterated on and off over three or four days, with hands-on time of just a dozen minutes per round.
