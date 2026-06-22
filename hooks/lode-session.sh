#!/usr/bin/env bash
# Lodestar self-evolution trigger (SessionStart hook).
# First principle: the evolution entry shouldn't rely on the model's memory — a program checks the
# signal queue at session start. Counts pending signals across all .lode/*/signals.jsonl; if any,
# prompts to run /lode-evolve. Never blocks (exit 0).
set -euo pipefail
cd "${CLAUDE_PROJECT_DIR:-.}" 2>/dev/null || true
shopt -s nullglob 2>/dev/null || true
total=0
for f in .lode/*/signals.jsonl; do
  [ -f "$f" ] || continue
  n=$(grep -c . "$f" 2>/dev/null || echo 0)
  total=$((total + n))
done
[ "$total" -gt 0 ] && echo "[Lodestar] $total correction signal(s) pending → run /lode-evolve to distill them into rules (self-evolution)."
exit 0
