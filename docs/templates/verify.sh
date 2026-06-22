#!/usr/bin/env bash
# Deterministic verification script — laid down by lode-init / lode-build to .lode/verify.sh.
# Purpose: wrap this project's "build + full regression tests" into one command, all pass => exit 0, any failure => non-zero.
# The Stop gate lode-gate.sh actually runs it — "did build/test pass" is a deterministic judgment, handed
# to a program, not the model's verbal self-assessment.
#
# From scratch: build + this project's tests is enough.
# Changing existing code: MUST run [the full existing suite + new tests], and compare against the pre-change baseline —
#             to tell "what you broke" from "what was already broken."
#             Save the baseline once before touching anything:
#             `bash verify.sh > .lode/baseline.md 2>&1 || true`
set -euo pipefail

# ── Unconfigured guard (don't delete the wrong thing) ─────────────────
# This is a skeleton: until you fill in real build/test commands, the gate should hard-block,
# not silently pass with exit 0. After filling in the real commands below, flip the 0 to 1:
LODE_VERIFY_CONFIGURED=0
if [ "${LODE_VERIFY_CONFIGURED}" != "1" ]; then
  echo "verify.sh is not configured: replace the placeholders with this project's real build + full test, then set LODE_VERIFY_CONFIGURED=1." >&2
  exit 1
fi
# ──────────────────────────────────────────────────────────────────────

# Replace the commands below for your stack (drop the # and fill in real commands):

# 1) Build
# npm run build

# 2) Full regression tests (existing + new; changing existing code especially must not run only this slice's tests)
# npm test

# 3) Optional: typecheck / lint (universal invariants — recommend gating these too)
# npm run typecheck
# npm run lint
