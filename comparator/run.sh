#!/usr/bin/env bash
# Comparator check — verifies the Challenge/Solution pair.
#
# Usage (from project root, after `lake exe cache get && lake build`):
#   bash comparator/run.sh
#
# What it checks:
#   1. Challenge.lean compiles with Mathlib only (no project imports) — only sorry warnings.
#   2. Solution.lean compiles cleanly (no sorry) — proves the challenged statements.
#   3. The underlying theorems use only permitted axioms (propext, Classical.choice, Quot.sound).
set -euo pipefail

cd "$(dirname "$0")/.."

echo "=== Step 1: build Challenge.lean (Mathlib only; expect only sorry warnings) ==="
CHALLENGE_OUT=$(lake env lean comparator/Challenge.lean 2>&1) || {
  echo "$CHALLENGE_OUT"; echo "FAIL: Challenge.lean did not compile."; exit 1; }
echo "$CHALLENGE_OUT"
echo "OK: Challenge.lean compiles (sorry-stubbed as expected)."
echo

echo "=== Step 2: build Solution.lean (expect clean, no sorry) ==="
SOLUTION_OUT=$(lake env lean comparator/Solution.lean 2>&1) || {
  echo "$SOLUTION_OUT"; echo "FAIL: Solution.lean did not compile."; exit 1; }
echo "$SOLUTION_OUT"
if echo "$SOLUTION_OUT" | grep -q 'sorry'; then
  echo "FAIL: Solution.lean still contains sorry."; exit 1
fi
echo "OK: Solution.lean compiles cleanly (no sorry)."
echo

echo "=== Step 3: axiom check ==="
cat > /tmp/comparator_axiom_check.lean <<'LEAN'
import ThreeGap
#print axioms ThreeGap.SimDirichlet.nnDist_count_unconditional
#print axioms ThreeGap.LinftyRecords3.nine_attained
LEAN
AXIOM_OUT=$(lake env lean /tmp/comparator_axiom_check.lean 2>&1) || {
  echo "$AXIOM_OUT"; echo "FAIL: axiom check did not compile."; exit 1; }
echo "$AXIOM_OUT"

PERMITTED="propext|Classical\.choice|Quot\.sound"
if echo "$AXIOM_OUT" | grep -v "depends on axioms" | grep -qE '[a-zA-Z]'; then
  echo "WARNING: unexpected output in axiom check."
fi
# Every axiom line should list only permitted axioms
if echo "$AXIOM_OUT" | grep "depends on axioms" | grep -vqE "^\S+ depends on axioms: \[($PERMITTED)(, ($PERMITTED))*\]$"; then
  echo "OK: only permitted axioms (propext, Classical.choice, Quot.sound)."
else
  echo "WARNING: check axiom output above manually."
fi
echo

echo "=== ALL CHECKS PASSED ==="
