#!/usr/bin/env bash
# Lodestar wrap-up gate (Stop hook).
# First principle: anything a program can judge becomes a hard gate — not the model's good intentions,
#   and not just a model-written flag.
#
# Two hard checks (only blocks a workspace where dev has STARTED = changelog.md exists; spec/plan pass):
#   ① Deterministic verification: actually run .lode/verify.sh (build + full test); the exit code decides.
#      — Skipped (cached) when the fingerprint is unchanged and last run was green (no full rebuild every Stop).
#   ② Review passed: review-passed is non-empty AND contains the CURRENT code fingerprint —
#      blocks "reviewed then edited", empty touch, and faked markers.
#
# Subcommand:
#   lode-gate.sh fingerprint   print the current code fingerprint (lode-review writes it into review-passed)
#
# Exit codes: 0 pass; 2 block wrap-up and feed stderr back to the model.
#   After ≥ LODE_GATE_MAX_ATTEMPTS (default 5) consecutive blocks → breaker: pass and hand to the human.
set -euo pipefail

# Anchor to project root (#7: when cwd isn't the root, prefer the Claude-provided project dir)
cd "${CLAUDE_PROJECT_DIR:-.}" 2>/dev/null || true

# Pick an available sha256 tool
_sha() { if command -v shasum >/dev/null 2>&1; then shasum -a 256; else sha256sum; fi; }

# Code fingerprint: git repo → HEAD + staged + working-tree changes (content-level, accurate);
# non-git → content hash of working-tree files (excludes build/dep dirs; no .gitignore awareness).
fingerprint() {
  if git rev-parse --git-dir >/dev/null 2>&1; then
    { git rev-parse HEAD 2>/dev/null || true
      git status --porcelain 2>/dev/null || true
      git diff 2>/dev/null || true; } | _sha | awk '{print $1}'
  else
    find . -type d \( -name .git -o -name .lode -o -name node_modules -o -name dist -o -name build \
        -o -name target -o -name .next -o -name vendor -o -name __pycache__ \) -prune -o \
      -type f -print0 2>/dev/null \
      | LC_ALL=C sort -z | xargs -0 cat 2>/dev/null | _sha | awk '{print $1}'
  fi
}

# Subcommand: print fingerprint for lode-review to embed in review-passed
if [ "${1:-}" = "fingerprint" ]; then fingerprint; exit 0; fi

# Consume stdin (the Stop hook JSON); don't block, don't depend on it
cat >/dev/null 2>&1 || true

# Has dev started (.lode/changelog.md exists)? If not => pass (spec/plan stage, or a non-Lodestar project)
[ -f ".lode/changelog.md" ] || exit 0

MAX_ATTEMPTS="${LODE_GATE_MAX_ATTEMPTS:-5}"
ATTEMPTS_FILE=".lode/.gate-attempts"

# Breaker counter (#5): consecutive blocks accumulate; reset on pass
block() {
  local n=0; [ -f "$ATTEMPTS_FILE" ] && n=$(cat "$ATTEMPTS_FILE" 2>/dev/null || echo 0)
  n=$((n + 1)); echo "$n" > "$ATTEMPTS_FILE" 2>/dev/null || true
  if [ "$n" -ge "$MAX_ATTEMPTS" ]; then
    echo "[Lodestar breaker] The gate has blocked $n times in a row without passing — stopping, over to you." >&2
    echo "The gate blocks 'bad completion'; the breaker blocks 'expensive non-completion'. See the last failure above." >&2
    rm -f "$ATTEMPTS_FILE" 2>/dev/null || true
    exit 0
  fi
  exit 2
}
pass() { rm -f "$ATTEMPTS_FILE" 2>/dev/null || true; exit 0; }

FP="$(fingerprint 2>/dev/null || true)"

LODE_DIR=".lode/"
VERIFY="${LODE_DIR}verify.sh"
PASS_MARK="${LODE_DIR}review-passed"
CACHE="${LODE_DIR}.verify-green"

# ① Deterministic verification
if [ -f "${VERIFY}" ]; then
  if [ -n "${FP}" ] && [ -f "${CACHE}" ] && [ "$(cat "${CACHE}" 2>/dev/null || true)" = "${FP}" ]; then
    :   # this exact code state already verified last time => skip rerun (#4 cache)
  elif VERIFY_OUT=$(bash "${VERIFY}" 2>&1); then
    echo "${FP}" > "${CACHE}" 2>/dev/null || true
  else
    echo "[Lodestar gate] Blocking wrap-up: ${VERIFY} failed (build/test did not pass)." >&2
    echo "--- verify.sh output (last 40 lines) ---" >&2
    printf '%s\n' "${VERIFY_OUT}" | tail -40 >&2
    block
  fi
else
  echo "[Lodestar gate] Blocking wrap-up: dev has started but ${VERIFY} is missing." >&2
  echo "Create ${VERIFY} (wrap this project's build + full test, exit 0 when all pass; skeleton in docs/templates/verify.sh)." >&2
  block
fi

# ② Review marker non-empty (no empty touch)
if [ ! -s "${PASS_MARK}" ]; then
  echo "[Lodestar gate] Blocking wrap-up: missing non-empty review marker ${PASS_MARK}." >&2
  echo "Run lode-review on this round of changes; on pass, write the verdict into ${PASS_MARK} plus this fingerprint line:" >&2
  echo "  tree: ${FP}" >&2
  block
fi

# ② Marker must contain the CURRENT code fingerprint (#2 reviewed-then-edited, #6 anti-fake)
if [ -n "${FP}" ] && ! grep -qF "${FP}" "${PASS_MARK}"; then
  echo "[Lodestar gate] Blocking wrap-up: the fingerprint in ${PASS_MARK} doesn't match current code — it changed after review; re-review needed." >&2
  echo "After re-reviewing, update this line in ${PASS_MARK}:" >&2
  echo "  tree: ${FP}" >&2
  block
fi

pass
