---
name: lode-skill
description: "Lodestar extension — build a new skill. Write a capability into a new Skill. Use when the user needs to add a new capability to the system or product, or to create/rewrite a SKILL.md. Trigger: /lode-skill"
---

# Skill Builder

Extension skill. Distill a capability into a new `SKILL.md`. The paradigm's skill for making skills.

## Usage (when to use)

- A new capability is needed for the system (or the agent product being built).
- An existing Skill is written wrong (turned into an operations manual, or shredded too fine) and needs a rewrite.

## Done (what counts as acceptable)

Produce a paradigm-compliant `SKILL.md`:
- Frontmatter has a clear `name` and `description` (the description decides when it triggers — write it precisely).
- The body covers only **three things**:
  - **Usage**: when to use it.
  - **Done**: what counts as acceptable.
  - **Guardrails**: which red lines must not be crossed.
- Leave "how exactly to do it" for the model to organize itself; only thicken where "what counts as good" needs to be thick (e.g. a question bank).
- For larger capabilities, put reference material in the skill's own `references/` and leave only pointers in the body (progressive disclosure) — don't write external relative paths into the body, they break after install.

## Pre-release minimal self-test (the "hit-the-pitfall-then-fix" approach, shipped early)

Don't wrap up the draft directly — run a minimal eval first. This is the **pre-release** version of "grow rules only from real failures":

1. Write **2–3 realistic trigger prompts** (the kind a real user would actually say), confirm them with the user at a glance.
2. Run each and watch two things: **does it trigger accurately** (triggers when it should, doesn't steal from other skills), and **is the output up to standard** (against this skill's Done).
3. If it fails, fix the `description` (trigger problem) or the body's standards (output problem), and rerun until stable.
4. The most common root cause of inaccurate triggering is a `description` that's not specific enough or that collides with an installed skill — tune that first.

> Skills with objectively verifiable output (file transforms / data extraction / fixed workflows) deserve this step; purely subjective style ones (copy / aesthetics) can skip it.

## Guardrails (red lines)

- **Build fewer tools, grant more capability.** Don't shred a capability into a little pile of special-purpose tools (one to find subtitles, one to cut a clip…) — that's actually dumber. Grant the full general capability and let the model compose it — **smartness is released, not designed.**
- Don't write a step-by-step operations manual (the finer you write it, the more you cap the model's ceiling).
- Rules a program can judge should be made into hook gates, not written into the Skill for the model to recite over and over.
- Confirm a new skill's positioning and boundaries with the user before landing it.
