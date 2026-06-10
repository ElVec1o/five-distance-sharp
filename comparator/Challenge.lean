import Mathlib
open Finset

/-!
# Five-distance / sup-norm gap theorems — claims (Mathlib only)

This file imports **only Mathlib**. Read it on its own to see exactly what is claimed; you do not
need to read the project at all. The statements are `sorry`-stubbed here; the project supplies the
proofs (see `Solution.lean`), and the comparator checks the project proves *these* statements with no
axioms beyond `propext`, `Classical.choice`, `Quot.sound`.

For `α : Fin d → ℝ`, the orbit `{0, α, …, Nα}` on the torus `(ℝ/ℤ)ᵈ`. `supDelta α q` is the sup-norm
distance from `q • α` to the integer lattice; `supNN α N q` is the sup-norm nearest-neighbour distance
of the `q`-th orbit point to the others. `g_∞` counts the distinct such distances.
-/

namespace FiveDistanceSpec

/-- Sup-norm approximation defect `δ_q = ⨅ over integer vectors p of ‖q • α − p‖`. -/
noncomputable def supDelta {n : ℕ} (α : Fin n → ℝ) (q : ℤ) : ℝ :=
  ⨅ p : Fin n → ℤ, ‖(q : ℝ) • α - (fun k => (p k : ℝ))‖

/-- Sup-norm nearest-neighbour distance of `qα` among `{0, α, …, Nα}`. -/
noncomputable def supNN {d : ℕ} (α : Fin d → ℝ) (N q : ℕ) : ℝ :=
  if h : ((range (N + 1)).erase q).Nonempty then
    ((range (N + 1)).erase q).inf' h (fun j => supDelta α ((q : ℤ) - (j : ℤ))) else 0

/-- **g_∞ ≤ 2^d + 1.** At most `2^d + 1` distinct sup-norm nearest-neighbour distances. -/
theorem supnorm_count_le {d : ℕ} (α : Fin d → ℝ) {k₀ : Fin d} (hirr : Irrational (α k₀))
    {N : ℕ} (hN : 2 ≤ N) : ((range (N + 1)).image (supNN α N)).card ≤ 2 ^ d + 1 := sorry

/-- **g_∞(3) = 9 is attained.** An explicit `α : Fin 3 → ℝ` with an irrational coordinate and an `N`
realizing exactly 9 distinct sup-norm nearest-neighbour distances on `(ℝ/ℤ)³`. -/
theorem nine_attained_spec :
    ∃ α : Fin 3 → ℝ, (∃ k, Irrational (α k)) ∧
      ∃ N, 2 ≤ N ∧ ((range (N + 1)).image (supNN α N)).card = 9 := sorry

end FiveDistanceSpec
