#!/usr/bin/env bash
# Lodestar completion gate (Stop hook).
# First principle: what a program can judge becomes a gate that hard-blocks — don't rely on the model's
#                  good intentions, and don't trust only a flag the model wrote.
#
# This gate has two layers, both required:
#   ① Deterministic verification (hard): run .lode/<project>/verify.sh (project build+test script),
#      verdict by exit code. — "build with zero errors / all tests pass" is the most deterministic
#      judgment; the gate must actually run it, not stuff it into a model self-assessment.
#   ② Review-passed marker (soft): REVIEW_PASSED exists, is newer than the latest dev (CHANGELOG).
#      — prevents "changed but wrapped up without re-review." The marker must carry verifiable content
#      (the reviewed Face/commit id), not an empty touch.
#
# Rule: only block a workspace where development has started (CHANGELOG.md exists).
#       The spec/design/plan phases (no code yet) pass through.
#
# Exit codes: 0 allow; 2 block wrap-up and feed stderr back to the model to keep working.

set -euo pipefail

# Most recently modified lode workspace (by mtime, not alphabetical)
LODE_DIR=$(ls -dt .lode/*/ 2>/dev/null | head -1 || true)

# No lode workspace => not a Lodestar flow, allow
[ -z "${LODE_DIR}" ] && exit 0

CHANGELOG="${LODE_DIR}CHANGELOG.md"
PASS_MARK="${LODE_DIR}REVIEW_PASSED"
VERIFY="${LODE_DIR}verify.sh"

# Development hasn't started (no CHANGELOG) => early phase, don't block
[ -f "${CHANGELOG}" ] || exit 0

# ① Deterministic verification: if verify.sh exists, actually run it; non-zero exit hard-blocks (build/test gate)
if [ -f "${VERIFY}" ]; then
  if ! VERIFY_OUT=$(bash "${VERIFY}" 2>&1); then
    echo "[Lodestar gate] Blocking wrap-up: deterministic verification ${VERIFY} failed (build/test not passing)." >&2
    echo "--- verify.sh output (last 40 lines) ---" >&2
    echo "${VERIFY_OUT}" | tail -40 >&2
    echo "Fix until verify.sh exits 0, then wrap up." >&2
    exit 2
  fi
else
  # No verify.sh: lode-plan/lode-build should lay down a project build+test script when dev starts.
  echo "[Lodestar gate] Blocking wrap-up: development has started but the deterministic verification script ${VERIFY} is missing." >&2
  echo "Create ${VERIFY} (wrap this project's build+test commands, all pass => exit 0), so build/test are actually run by the gate rather than verbally self-assessed by the model." >&2
  exit 2
fi

# ② Review marker exists
if [ ! -f "${PASS_MARK}" ]; then
  echo "[Lodestar gate] Blocking wrap-up: no review-passed marker ${PASS_MARK} found." >&2
  echo "First use lode-review to fan out an independent review subagent for this change; on pass, write ${PASS_MARK} (state the reviewed Face/commit id), then wrap up." >&2
  exit 2
fi

# ② Marker must not be an empty file (prevents `touch REVIEW_PASSED` empty pass-through)
if [ ! -s "${PASS_MARK}" ]; then
  echo "[Lodestar gate] Blocking wrap-up: ${PASS_MARK} is empty." >&2
  echo "The marker must state the reviewed Face/commit id (verifiable); an empty touch is not accepted." >&2
  exit 2
fi

# ② Marker older than CHANGELOG => there are changes not re-reviewed
if [ "${CHANGELOG}" -nt "${PASS_MARK}" ]; then
  echo "[Lodestar gate] Blocking wrap-up: CHANGELOG is newer than the review marker; there are un-re-reviewed changes." >&2
  echo "Re-review, then update ${PASS_MARK}." >&2
  exit 2
fi

exit 0
