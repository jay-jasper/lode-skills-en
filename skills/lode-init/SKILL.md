---
name: lode-init
description: "Lodestar extension skill · project init (optional manual escape hatch). One-shot scaffolds the per-project files: top-level CLAUDE.md + .lode/verify.sh + the .lode directory. Note: in the normal flow these are provisioned automatically — CLAUDE.md is dropped by lode-spec at the start, verify.sh is written by lode-build when development starts; the user need not invoke this. Use only to pre-scaffold manually, or to repair when auto-provisioning didn't kick in. Trigger: /lode-init"
---

# Init (project initialization · optional manual escape hatch)

Extension skill. Lays down the per-project files in one shot.

> **You normally don't run this**: these files are provisioned automatically — `CLAUDE.md` is dropped by `lode-spec` the moment you enter a project, and `verify.sh` is written by `lode-build` with real commands when development starts. This skill is just a **manual escape hatch**: use it to pre-scaffold before starting, or to repair if auto-provisioning didn't kick in.

## Usage (when to use)

- You want to **manually pre-scaffold** the per-project files before starting.
- Auto-provisioning didn't kick in (e.g. spec/build couldn't find the rules source) and you need to fix it by hand.

## What it does (scaffold three things, fill what's missing)

1. **Top-level rules `CLAUDE.md` → project root**: Lodestar's operating conventions.
   - Source location: plugin install → `${CLAUDE_PLUGIN_ROOT}/CLAUDE.md`; script install → `~/.claude/lodestar/CLAUDE.md`. Probe with `echo "$CLAUDE_PLUGIN_ROOT"` first; if empty, look under `~/.claude/lodestar/`; **if you can't find it, stop and ask the user where Lodestar is installed** — don't regenerate one from memory (it'll be stale).
2. **`.lode/verify.sh` skeleton**: copy from `~/.claude/lodestar/templates/verify.sh` (plugin install: `${CLAUDE_PLUGIN_ROOT}/docs/templates/verify.sh`), `chmod +x`. **Lay the skeleton now; the real commands are normally written by the first `lode-build`**.
3. **`docs/` + `.lode/` directories + `.gitignore`**: create `docs/` (holds `spec.md`/`spec-changelog.md`/`architecture.md`) and `.lode/` (runtime artifacts); and ensure the project `.gitignore` **ignores `.lode/`** (runtime stays out of git) and **tracks `docs/`** (`spec*.md` and `architecture.md` are both deliverables).

> A script install (non-plugin) still needs the `hooks` block from `hooks/settings.json` merged into `.claude/settings.json` — that's not lode-init's job, see README. A plugin install already has the gate active.

## Done (what counts as good)

- The project root has `CLAUDE.md` (created this run, or confirmed present with a merge note).
- `.lode/verify.sh` exists and is executable.
- Close with a one-line pointer: from scratch → next is `lode-spec`, changing existing code → next is still `lode-spec` (it gets architecture ready at the start).

## Guardrails (red lines)

- **Never overwrite an existing `CLAUDE.md` / `verify.sh`**: if the project already has a `CLAUDE.md` (likely the user's own project rules), leave it; only with the user's OK append Lodestar rules in a `<!-- LODESTAR:BEGIN/END -->` block; keep an existing `verify.sh`. Never silently clobber their files.
- **Scaffold only**: don't guess the project's build/test commands — that's `lode-spec`'s start / `lode-build`'s job.
- If you can't find the source files, stop and ask; don't fabricate a stale `CLAUDE.md`.
