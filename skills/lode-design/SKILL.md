---
name: lode-design
description: "Lodestar mainline ③ (optional) — design mockups & prototypes. Generate high-fidelity mockups and clickable prototypes from the Design Brief. Use when you need to see the real interface before coding, or build a clickable prototype to validate interactions. Skeleton-first, no feature sneaking. Trigger: /lode-design"
---

# Design Maker (Mockups & Prototypes · optional)

Mainline step ③ (optional). Turn `Design-Brief.md` into **high-fidelity mockups / clickable prototypes**, so people can see and click the real interface before any production code is written.

## Usage (when to use)

- `Design-Brief.md` is ready, and the interface is make-or-break for the product, worth validating first.
- The user wants to "see something" before deciding whether to go this way.
- The interaction is complex; static description can't capture it, and a clickable prototype is needed to align expectations.

## How to make it (skeleton first)

- **Skeleton first, then increments**: ship the thinnest runnable skeleton, confirm it, then layer on one piece at a time. **Don't let it produce something too complex in one shot** — it tends to break, and it hides a pile of features you never asked for across the pages, which are a pain to delete later (a pitfall the author called out explicitly).
- You can leverage the installed `open-design` MCP or `frontend-design` / `imagegen-frontend-web` skills to carry the generation.

## Done (what counts as acceptable)

Produce `.lode/<project>/mockups/` (high-fidelity HTML/JSX etc. that runs in a browser), satisfying:
- Strictly lands the Design Brief's tokens and direction; don't start a second style.
- Covers the key pages and key states (empty/loading/error) of the core flow.
- The prototype clicks through the main flow — not a pile of dead images.
- Consistent with the Product-Spec's scope; don't draw out-of-scope pages.
- **List "what was added extra"**: separately list elements you added beyond the Design-Brief, for the user to confirm/delete, keeping it under control.
- The produced **design code is directly reusable by development** (hand off to the terminal / export a project bundle into the project directory), so lode-build builds on it directly instead of rewriting.

## Guardrails (red lines)

- This is an **optional step**: when the interface isn't critical, skip it — don't do it for its own sake.
- **No feature sneaking**: any element beyond the Design-Brief must be explicitly flagged, not quietly slipped in.
- The prototype exists to align expectations, not to be the final product — don't pile production-grade engineering structure here.
- Don't free-style away from the Design Brief; to change direction, go back to `/lode-brief`.
- Confirm the output with the user before entering `lode-plan`.
