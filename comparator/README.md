# Comparator / faithful statements

`Challenge.lean` restates the headline results of this project using **only Mathlib notions**
(sup-norm defect `⨅ p, ‖q•α − p‖`, nearest-neighbour distance, `Finset.image (...).card`), and
**proves each one from the project's own theorem**. Because the file compiles with no `sorry` and no
extra axioms, it certifies that the project's named theorems really do prove these human-readable
statements — no vacuity, no hidden weakening:

- `FiveDistanceSpec.supnorm_count_le` — `g_∞ ≤ 2^d + 1` (sup-norm gap bound, all `d`).
- `FiveDistanceSpec.nine_attained_spec` — `g_∞(3) = 9` is attained: an explicit irrational `α`
  and `N` realizing exactly 9 distinct sup-norm nearest-neighbour distances on `𝕋³`.
- `FiveDistanceSpec.supNN_eq` — the self-contained `supNN` is *definitionally* the project's `nnDist`.

Check it yourself (the project must be built first, `lake exe cache get && lake build`):

```
lake env lean comparator/Challenge.lean      # compiles ⇒ statements verified faithful
```

`config.json` lists the certified statements and the permitted axiom set
(`propext`, `Classical.choice`, `Quot.sound`) for a sandboxed run with
[leanprover/comparator](https://github.com/leanprover/comparator).
