# five-distance-sharp

[![DOI](https://zenodo.org/badge/1258602739.svg)](https://doi.org/10.5281/zenodo.20532459)

Sharp finite-distance theorems for Kronecker sequences on higher-dimensional tori, in Lean 4 /
Mathlib, by Vico Bonfioli. Apache-2.0.

## What it proves

**Euclidean metric (`𝕋²`):**
- `ThreeGap.EuclideanRecords.nnDistE_count_le_five` — at most **5** distinct Euclidean
  nearest-neighbour distances (Haynes–Marklof five-distance theorem).
- `ThreeGap.EuclideanRecords.sharp_attained` — an explicit `α` (irrational coordinate) and `N`
  realizing exactly **5** → the bound is sharp, `g₂ = 5`.

**Maximum metric (`𝕋^d`, sup norm):**
- `ThreeGap.SimDirichlet.nnDist_count_unconditional` — at most **`2^d + 1`** distinct sup-norm
  nearest-neighbour distances, in **all dimensions** (Shutov; dynamics-free).
- `ThreeGap.LinftyRecords.sharp_attained` — `d = 2`: 5 attained → `g_∞(2) = 5`.
- `ThreeGap.LinftyRecords3.nine_attained` — `d = 3`: ≥ 9 attained; with the `≤ 9` bound this gives
  **`g_∞(3) = 9`** (Haynes–Ramirez, sharp for `d ≤ 3`). Witness
  `α = (−157/10000, −742/3125, −23/400)`, `N = 73`.

The sharpness witnesses are **dynamics-free and integer-exact** (the sup-norm defect is a max of
balanced residues — no square roots; the Euclidean defect a sum of two), transported to an irrational
coordinate by a Lipschitz perturbation.

## Status

- **Sorry-free, axiom-clean** (`[propext, Classical.choice, Quot.sound]`; no `native_decide`).
- Witnesses independently re-verified by direct nearest-neighbour computation (Euclidean d=2 → 5,
  sup-norm d=2 → 5, sup-norm d=3 → 9).
- Each "sharp" headline is the *pairing* of an upper-bound theorem with a lower-bound witness theorem,
  both present here.

## Relation to Mathlib

None of this is in Mathlib. These are recent results (Haynes–Marklof 2022, Shutov 2024,
Haynes–Ramirez 2021) formalized here.

## Open

`d ≥ 4` sup-norm sharpness is **open in the literature itself** (the `2^d+1` bound is conjectured not
to be tight there) — not a formalization gap.

## Build

```
lake exe cache get
lake build
```

## Citation

If you use this work, please cite it via its Zenodo DOI:

> Vico Bonfioli. *Sharp five-distance and sup-norm gap theorems for Kronecker sequences (Lean 4 / Mathlib)*. Zenodo. <https://doi.org/10.5281/zenodo.20532459>

`10.5281/zenodo.20532459` is the concept DOI (always resolves to the latest version); the `v1.0.0`
release is archived at `10.5281/zenodo.20532458`.

## Acknowledgements

Developed by Vico Bonfioli with substantial assistance from Anthropic's Claude (an AI assistant)
for proof development, refactoring, and verification. Soundness does not rest on that assistance: every
theorem is checked by the Lean 4 kernel and is axiom-clean (`propext`, `Classical.choice`, `Quot.sound`),
with no `sorry` and no `native_decide`.
