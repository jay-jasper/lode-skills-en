---
name: lode-brief
description: "Lodestar mainline ② — design-brief interview that translates the user's \"feel\" into concrete design decisions. Use when the product-spec is ready and you need to settle the visual/interaction direction — tone, palette, typography, component conventions. Multiple-choice interview + anti-reference. Trigger: /lode-brief"
---

# Design Brief Builder

Mainline step ②. Like a designer interviewing a client: take the vague "feel/tone" in the user's head and, through interview, translate it into **concrete, executable design decisions**.

## Usage (when to use)

- `product-spec.md` is confirmed; entering the design phase (this step is optional).
- The user has expectations about the look but can only describe them with adjectives ("more premium," "clean," "techy").
- Before building a high-fidelity mockup (`lode-design`) or writing frontend, settle the conventions first.

## How to ask (turn "feel" into concrete decisions)

Lean on a question bank (starter template in this skill's `references/question-bank-design.md`), converging item by item with **multiple choice**:

1. **Combo references + give a recommendation**: for each axis, offer 2–3 **concrete product combos** to pick from, and give your recommendation.
   e.g.: "① CapCut structure + Linear vibe ② CapCut + Cursor engineering feel ③ DaVinci + heavy console feel — I recommend ①."
   Walk every axis: first-impression reference / theme color (dark·light) / information density / corner-radius hierarchy / typography / agent-status presentation / icons / list vs grid / preview pane / empty state / copy tone.
2. **Anti-reference (one mandatory question)**: "What must **absolutely never** appear? Which products' feel do you **hate**?" — anti-references pin down direction better than positive references.
3. **Rejected → swap in a new batch**: when the user says "too AI / not right," immediately offer a new set of options (e.g. palette cold-blue → amber/warm-white/coral). Converge by iterating, don't get stuck.
4. **Leverage installed skills**: you can call `high-end-visual-design` / `frontend-design` / `design-taste-frontend` and ECC `web/design-quality` rules to avoid a template look.

## Done (what counts as acceptable)

Produce `.lode/<project>/design-brief.md` that satisfies:
- A **clear design direction** chosen (editorial/magazine, neo-brutalism, glassmorphism, Swiss…), not empty phrases like "clean minimal."
- Both **reference and anti-reference** written out (what we want + what we absolutely don't).
- Actionable design tokens: palette (incl. semantic colors), type pairing, spacing/radius/shadow rhythm.
- Key states: hover / focus / active / disabled / empty / loading / error.
- Accessibility and responsive baselines (contrast, reduced-motion, breakpoints).
- Information architecture + page list (with page relationships); every decision traces back to the product-spec's users and scenarios.

## Guardrails (red lines)

- Refuse the template look: don't default to dark mode; no cookie-cutter card grid + centered headline + gradient blob.
- Turn "feel" into judgeable conventions; leave no "use your judgment" gaps.
- Don't write code or generate full pages in this step (that's lode-design / lode-build).
- Confirm the direction with the user before expanding.

## → Next
Design decisions set → `/lode-design` for a prototype (optional), or straight to `/lode-plan`.
