---
name: lode-design
description: "Lodestar mainline ③ (optional) — design mockups & prototypes. Generate high-fidelity mockups and clickable prototypes from the Design Brief. Use when you need to see the real interface before coding, or build a clickable prototype to validate interactions. Skeleton-first, no feature sneaking. Trigger: /lode-design"
---

# Design Maker (Mockups & Prototypes · optional)

Mainline step ③ (optional). Turn `design-brief.md` into **high-fidelity mockups / clickable prototypes**, so people can see and click the real interface before any production code is written.

## Usage (when to use)

- `design-brief.md` is ready, and the interface is make-or-break for the product, worth validating first.
- The user wants to "see something" before deciding whether to go this way.
- The interaction is complex; static description can't capture it, and a clickable prototype is needed to align expectations.

## How to make it (skeleton first)

- **Skeleton first, then increments**: ship the thinnest runnable skeleton, confirm it, then layer on one piece at a time. **Don't let it produce something too complex in one shot** — it tends to break, and it hides a pile of features you never asked for across the pages, which are a pain to delete later.
- You can leverage the installed `open-design` MCP or `frontend-design` / `imagegen-frontend-web` skills to carry the generation.

## How to view it (the output must be directly viewable)

- **Prefer self-contained, double-click-to-open**: if plain HTML (or HTML + CDN) works, don't use something that needs a build; for multiple screens, generate an `index.html` that links them so it opens with a double-click.
- **Always end with one view command**: static & openable → `open .lode/mockups/index.html`; must run a server (React/bundled) → give the start command (e.g. `npx serve .lode/mockups`).
- You can use `screenshot` / `playwright` / `/run` to open or screenshot it yourself and put the interface in front of the user — don't make them guess how to open it.

## Done (what counts as acceptable)

Produce `.lode/mockups/` (high-fidelity HTML/JSX etc. that runs in a browser), satisfying:
- Strictly lands the Design Brief's design tokens and direction; don't start a second style.
- Covers the key pages and key states (empty/loading/error) of the core flow.
- The prototype clicks through the main flow — not a pile of dead images.
- Consistent with the spec's scope; don't draw out-of-scope pages.
- **List "what was added extra"**: separately list elements you added beyond the design-brief, for the user to confirm/delete, keeping it under control.
- The produced **design code is directly reusable by development** (hand off to the terminal / export a project bundle into the project directory), so lode-build builds on it directly instead of rewriting.
- **Give a way to view it**: end with one command that shows the prototype (`open …/index.html` or a start command) so the user sees it with a single click.

## Guardrails (red lines)

- **Can't see it = not done**: if you can't give a way to view it, or the output won't open, it doesn't count as Done.
- This is an **optional step**: when the interface isn't critical, skip it — don't do it for its own sake.
- **No feature sneaking**: any element beyond the design-brief must be explicitly flagged, not quietly slipped in.
- The prototype exists to align expectations, not to be the final product — don't pile production-grade engineering structure here.
- **New design supersedes the old in place**: when redesigning, update `mockups/` in place to the current version — don't pile up stale prototypes in the tree; reflect product-meaningful design decisions back into `docs/spec.md` (layout intent / key decisions) + one line in `docs/spec-changelog.md`.
- Don't free-style away from the Design Brief; to change direction, go back to `/lode-brief`.
- Confirm the output with the user before entering `lode-plan`.

## → Next
Prototype confirmed → `/lode-plan` to split into slices.
