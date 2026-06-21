#!/usr/bin/env bash
# Deterministic verification script — laid down by lode-build at dev start to .lode/<project>/verify.sh.
# Purpose: wrap this project's "build + test" into one command, all pass => exit 0, any failure => non-zero.
# The Stop gate lode-gate.sh actually runs it — "did build/test pass" is a deterministic judgment, handed
# to a program, not the model's verbal self-assessment.
#
# Replace the commands below for your stack. Example (Node/frontend project):
set -euo pipefail

# 1) Build
# npm run build

# 2) Test (unit + e2e)
# npm test

# 3) Optional: typecheck / lint
# npm run typecheck
# npm run lint

echo "verify.sh: replace the placeholder commands above with this project's real build+test commands."
exit 0
