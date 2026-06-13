# Comparator / faithful statements

`Challenge.lean` restates the headline results using **only Mathlib** — no project imports,
only `sorry`-stubbed claims. Read it on its own to see exactly what is proved.

`Solution.lean` imports the project and closes every `sorry` from the project's theorems.

## Certified statements

- `FiveDistanceSpec.supnorm_count_le` — `g_∞ ≤ 2^d + 1` (sup-norm gap bound, all `d`).
- `FiveDistanceSpec.nine_attained_spec` — `g_∞(3) = 9` is attained.
- `FiveDistanceSpec.supNN_eq` — `supNN` is *definitionally* the project's `nnDist` (`rfl`).

## Running the comparator

After building the project (`lake exe cache get && lake build`):

```
bash comparator/run.sh
```

This checks: (1) Challenge.lean compiles with only `sorry` warnings, (2) Solution.lean
compiles with no `sorry`, (3) only permitted axioms (`propext`, `Classical.choice`, `Quot.sound`).

### Latest run output

```
=== Step 1: build Challenge.lean (Mathlib only; expect only sorry warnings) ===
comparator/Challenge.lean:29:8: warning: declaration uses `sorry`
comparator/Challenge.lean:34:8: warning: declaration uses `sorry`
OK: Challenge.lean compiles (sorry-stubbed as expected).

=== Step 2: build Solution.lean (expect clean, no sorry) ===
OK: Solution.lean compiles cleanly (no sorry).

=== Step 3: axiom check ===
'ThreeGap.SimDirichlet.nnDist_count_unconditional' depends on axioms: [propext, Classical.choice, Quot.sound]
'ThreeGap.LinftyRecords3.nine_attained' depends on axioms: [propext, Classical.choice, Quot.sound]

=== ALL CHECKS PASSED ===
```

## CI

`.github/workflows/comparator.yml` runs these checks on push/PR when source files change.

## config.json

Lists certified statements and the permitted axiom set for
[leanprover/comparator](https://github.com/leanprover/comparator).
