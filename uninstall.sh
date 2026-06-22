#!/usr/bin/env bash
# Lodestar uninstaller (for the script install). Removes user-level Lodestar files + un-wires the gate
# from settings.json. By default it does NOT touch your per-project .lode/, project CLAUDE.md, verify.sh.
# With --purge-project it also deletes the CURRENT directory's .lode/ (prompts first when interactive;
# the project-root CLAUDE.md is still left alone).
#
# Usage:
#   bash ~/.claude/lode-uninstall.sh                      # tool only
#   bash ~/.claude/lode-uninstall.sh --purge-project      # also clear this project's .lode/
#   curl -fsSL https://raw.githubusercontent.com/Leejaywell/lode-skills-en/main/uninstall.sh | bash -s -- --purge-project
#   CLAUDE_HOME=/path bash uninstall.sh                   # custom Claude home
set -euo pipefail
DEST="${CLAUDE_HOME:-$HOME/.claude}"
PURGE=0; if [ "${1:-}" = "--purge-project" ]; then PURGE=1; fi

# 1) Un-wire the Lodestar gate from settings.json (remove only our two entries; keep all others; prune empties)
if [ -f "$DEST/settings.json" ] && command -v python3 >/dev/null 2>&1; then
  python3 - "$DEST/settings.json" <<'PY'
import json, shutil, sys
path = sys.argv[1]
try:
    with open(path) as f: s = json.load(f)
    if not isinstance(s, dict): raise ValueError
except Exception:
    sys.exit(0)  # unparseable — leave it alone
def ours(cmd): return "lode-hooks/lode-gate.sh" in cmd or "lode-hooks/lode-signal.sh" in cmd or "lode-hooks/lode-session.sh" in cmd
hooks = s.get("hooks", {}); changed = False
for event in list(hooks.keys()):
    groups = []
    for g in hooks.get(event, []):
        kept = [h for h in g.get("hooks", []) if not ours(h.get("command", ""))]
        if len(kept) != len(g.get("hooks", [])): changed = True
        if kept: g["hooks"] = kept; groups.append(g)
    if groups: hooks[event] = groups
    else: hooks.pop(event, None)
if not hooks: s.pop("hooks", None)
if changed:
    shutil.copy(path, path + ".bak")
    with open(path, "w") as f: json.dump(s, f, indent=2, ensure_ascii=False); f.write("\n")
    print("-> un-wired the gate from settings.json (original backed up to settings.json.bak)")
PY
fi

# 2) Remove Lodestar's own files (leaves your other skills/agents alone)
rm -rf "$DEST/lode-hooks" "$DEST/lodestar"
rm -rf "$DEST"/skills/lode-* 2>/dev/null || true
rm -f "$DEST"/agents/lode-review.md "$DEST"/agents/lode-recon.md "$DEST"/agents/lode-evolve.md 2>/dev/null || true
echo "Lodestar removed from $DEST (skills/subagents/gate scripts/source assets)."

# 3) Optional: clear the CURRENT directory's .lode/ (runtime docs)
if [ "$PURGE" = "1" ]; then
  if [ -d ".lode" ]; then
    ans=yes
    if [ -t 0 ]; then
      printf "Also delete ./.lode (all runtime docs in THIS project, unrecoverable)? [y/N] " >&2
      read -r reply; case "$reply" in y|Y|yes|YES) ans=yes;; *) ans=no;; esac
    fi
    if [ "$ans" = "yes" ]; then rm -rf ./.lode && echo "-> removed ./.lode"; else echo "-> kept ./.lode"; fi
  else
    echo "-> no ./.lode in the current directory."
  fi
  echo "   Note: the project-root CLAUDE.md / verify.sh are still left alone (may be your own rules) — remove by hand if you want."
else
  echo "   Your per-project .lode/, CLAUDE.md, verify.sh were left UNTOUCHED. To clear the docs too: run with --purge-project in the project, or 'rm -rf .lode'."
fi
echo "   (Plugin install instead? use: /plugin uninstall lodestar@lodestar  and  /plugin marketplace remove lodestar)"

# 4) Finally remove the uninstaller itself (only when $0 is the real script path, so curl|bash won't rm the wrong thing)
case "$0" in */lode-uninstall.sh) rm -f "$0" 2>/dev/null || true ;; esac
