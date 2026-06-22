#!/usr/bin/env bash
# Lodestar signal capture (UserPromptSubmit hook).
# First principle: a user correction is captured as a signal and handed to self-evolution. The hook,
#            by keyword, only catches the "obvious" corrections/dissatisfaction; the main agent
#            backfills what the hook missed (see CLAUDE.md).
#
# Behavior: read the UserPromptSubmit JSON from stdin, extract this turn's prompt text; if it hits a
#       correction/dissatisfaction keyword, append a signal to
#       .lode/signals.jsonl. Never blocks user input (always exit 0).
set -euo pipefail

cd "${CLAUDE_PROJECT_DIR:-.}" 2>/dev/null || true

INPUT=$(cat 2>/dev/null || true)

# Extract the prompt text (#8: match only the parsed prompt, not the whole JSON — avoid hitting field names/other fields).
PROMPT=""
if command -v jq >/dev/null 2>&1; then
  PROMPT=$(printf '%s' "${INPUT}" | jq -r '.prompt // .user_prompt // empty' 2>/dev/null || true)
else
  # No jq: best-effort extraction of the "prompt":"..." value; if it can't, give up (better to miss than to misfire).
  PROMPT=$(printf '%s' "${INPUT}" \
    | sed -n 's/.*"prompt"[[:space:]]*:[[:space:]]*"\(\([^"\]\|\\.\)*\)".*/\1/p' | head -1 || true)
fi
[ -z "${PROMPT}" ] && exit 0

# Correction/dissatisfaction keywords. Narrowed to clear signals; dropped over-broad words (bare "wrong"/"i said") to cut noise.
KEYWORDS="that's not what|that is not what|don't do that|do not do that|stop doing that|redo this|misunderstood|not what i (meant|asked)|you got it wrong|you misunderstood"

printf '%s' "${PROMPT}" | grep -qiE "${KEYWORDS}" || exit 0

# Not a lode project (no .lode/) → don't record
[ -d .lode ] || exit 0
SIGNALS=".lode/signals.jsonl"

TS=$(date -u +%Y-%m-%dT%H:%M:%SZ 2>/dev/null || echo "")

# Escape into a JSON string value
esc() { printf '%s' "$1" | sed 's/\\/\\\\/g; s/"/\\"/g' | tr '\n' ' '; }

printf '{"ts":"%s","type":"correction","source":"hook","prompt":"%s"}\n' \
  "${TS}" "$(esc "${PROMPT}")" >> "${SIGNALS}" 2>/dev/null || true

exit 0
