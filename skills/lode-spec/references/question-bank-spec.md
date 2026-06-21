# Requirements Question Bank (Spec) — starter template

> Used by lode-spec. Lands at `.lode/<project>/question-bank.md`.
> This is the vehicle for "delete the how-to, thicken the what-counts-as-good": it holds **questions + accept/push-back criteria**, not an interview script.
> Self-evolution only adds/changes/deletes here, and each change maps to one real failure.
>
> Usage: multiple-choice first (offer 2–3 concrete options to pick/reject); search the web first when domain knowledge is missing; only ask things only the user knows.

| Axis | Question (multiple-choice) | ✅ Acceptable answer | ❌ Must push back |
|---|---|---|---|
| Product form | Is v1 more like ① a tool ② an agent ③ generative? | Clearly pick one + a one-line reason | "Want it all" / can't say |
| Core scenario | What's the single highest-frequency main flow? | One flow that runs end to end | A pile of parallel scenarios |
| Scope boundary | Which capabilities are **deferred for this version**? | A clear deferral list | "Do as much as possible" |
| Automation level | Default auto-execute, or confirm each step? | Clearly one + risk tolerance | Vague |
| Done criteria | What counts as "done"? | Verifiable (quantifiable/demonstrable) | "Close enough" |
| Implementation-detail triage | (Things that are skill-customizable/implementation) don't ask the user | —— | Throwing impl details at the user |
| External dependencies | Which models/APIs/platforms does it depend on? | Listed + login/billing method | Left blank |

> Add your project-specific questions; fill the "accept / push-back" columns for every one.
