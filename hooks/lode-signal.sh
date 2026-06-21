#!/usr/bin/env bash
# Lodestar signal capture (UserPromptSubmit hook).
# First principle: a user correction is captured as a signal and handed to self-evolution. The hook,
#            by keyword, only catches the "obvious" corrections/dissatisfaction; the main agent
#            backfills what the hook missed (see CLAUDE.md).
#
# Behavior: read the UserPromptSubmit JSON from stdin, extract this turn's prompt text; if it hits a
#       correction/dissatisfaction keyword, append a signal to the most-recently-active
#       .lode/<project>/signals.jsonl. Never blocks user input (always exit 0).

set -euo pipefail

INPUT=$(cat 2>/dev/null || true)

# Extract the prompt text: prefer jq; without jq, fall back to keyword-matching the whole input
if command -v jq >/dev/null 2>&1; then
  PROMPT=$(printf '%s' "${INPUT}" | jq -r '.prompt // .user_prompt // empty' 2>/dev/null || true)
fi
[ -z "${PROMPT:-}" ] && PROMPT="${INPUT}"

# Correction/dissatisfaction keywords. Catch only the obvious ones to avoid noise.
KEYWORDS="wrong|that's not|that is not|don't do|do not do|stop doing|redo|misunderstood|not what i meant|incorrect|you got it wrong|i said"

echo "${PROMPT}" | grep -qiE "${KEYWORDS}" || exit 0

# Find the most-recently-active lode workspace
LODE_DIR=$(ls -dt .lode/*/ 2>/dev/null | head -1 || true)
[ -z "${LODE_DIR}" ] && exit 0

SIGNALS="${LODE_DIR}signals.jsonl"

# Timestamp (the hook runs in a real shell, date is available)
TS=$(date -u +%Y-%m-%dT%H:%M:%SZ 2>/dev/null || echo "")

# Escape into a JSON string value
esc() { printf '%s' "$1" | sed 's/\\/\\\\/g; s/"/\\"/g' | tr '\n' ' '; }

printf '{"ts":"%s","type":"correction","source":"hook","prompt":"%s"}\n' \
  "${TS}" "$(esc "${PROMPT}")" >> "${SIGNALS}"

# Never block input
exit 0
