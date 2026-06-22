# order instruction template

> Produced by lode-order. One order = the entry point that hands the objective to the AI to self-drive.
> Let the AI fill it from context; you glance and hit send.

```
Finish <goal>'s <dev-plan Phase N / slice N>: <one-line objective>

Done criteria:
1. <program-judgeable, e.g. becomes a runnable Electron + Vite + React + TS project>
2. <reuse existing static prototype code, not a from scratch rewrite>
3. .lode/verify.sh exits 0 (build with zero errors / all tests pass)
4. Review passes and is written into .lode/review-passed

Acceptance method:
- Key output of running verify.sh (build + test)
- List created/modified files
- State which prototype files were reused
- Four-step audit report: build verification / test completeness / Code Review / functional test

Constraints:
- Don't change docs/spec.md or design-brief.md, unless you find a contradiction that must be written back
- Don't move the settled UI baseline
- Don't touch business features outside this phase
- A local commit after each slice passes review is allowed as a rollback point; but **no push, don't delete prototype files**, unless the user confirms

Execution strategy: goal-oriented — when one path is blocked, try multiple methods before stopping; keep pushing long tasks until the order is achieved. Circuit breaker: stop and ask the human after ≥3 consecutive failures on the same slice or a token-budget overrun; don't retry forever.
```
