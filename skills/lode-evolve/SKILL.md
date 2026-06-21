---
name: lode-evolve
description: "Lodestar extension — self-evolution engine. Distill real failures / user corrections into rules, so the system understands you better over time while the rules don't keep growing. Auto-triggers when a new Session opens, or use when the user wants to retrospect and distill rules. Trigger: /lode-evolve"
---

# Evolution Engine (Self-Evolution)

Extension skill. The mechanism by which the system gets smarter: distill **real failures** into rules, so the system understands you better over time, while the rules don't keep growing.

## Mechanism (the loop)

```
You correct it / chew it out  →  record it as a Signal, append to .lode/<project>/signals.jsonl (signal queue)
   →  next time a Session opens, during the light self-check (docs/code/signal queue), fan out an Evolution Runner subagent to digest
   →  digest = analyze signals, abstract into rule proposals, write into proposals.md, and decide each: replace existing / supplement / plain-new
   →  lay each out and ask you (add/change/delete)  →  on your confirmation, land it into the relevant Skill's question-bank.md or the CLAUDE.md rule base
   →  clear the signals; the system returns to a fresh state
```

## Usage (when to use)

- Auto-triggers when a new Session opens (digest if the signal queue is non-empty).
- The user corrects / is dissatisfied, or the same class of pitfall is hit again.
- Periodic retrospective: clean out rules that don't get used.

## Done (what counts as acceptable)

- Abstract a Signal into a **concrete, executable** rule proposal, tag it with its source Signal, and decide replace/supplement/new.
- Lay each out for the user to **confirm**; don't write to the base unilaterally.
- On confirmation, write into the relevant `question-bank.md` (requirements/design rules) or the `<!-- RULES -->` section of `CLAUDE.md`.
- Reverse-cleanup while you're at it: when you find a rule that never triggers, proactively suggest deleting it.

## Guardrails (red lines)

- **Rules grow only from real failures**: don't pre-write rules for pitfalls you haven't hit.
- Proactively delete what isn't used — if deleting it makes the problem recur, that's what proves it was useful.
- Rules a program can judge should be made into hook gates, not written as "good-intentions" docs.
- One rule per real Signal; rules may only get more refined, never pile up.
