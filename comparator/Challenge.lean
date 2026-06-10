import ThreeGap
open Finset

/-!
# Self-contained statements of the headline theorems (Mathlib only)

Each `theorem` below restates a project result using only Mathlib notions, and is *proved* from
the project's own theorem. Compiling this file therefore certifies that the project's named
theorems really do prove these human-readable statements (no vacuity, no hidden weakening).
-/

namespace FiveDistanceSpec

/-- Sup-norm approximation defect `δ_q = inf over integer vectors p of ‖q•α − p‖`. -/
noncomputable def supDelta {n : ℕ} (α : Fin n → ℝ) (q : ℤ) : ℝ :=
  ⨅ p : Fin n → ℤ, ‖(q : ℝ) • α - (fun k => (p k : ℝ))‖

/-- Sup-norm nearest-neighbour distance of `qα` among the orbit `{0, α, …, Nα}`. -/
noncomputable def supNN {d : ℕ} (α : Fin d → ℝ) (N q : ℕ) : ℝ :=
  if h : ((range (N + 1)).erase q).Nonempty then
    ((range (N + 1)).erase q).inf' h (fun j => supDelta α ((q : ℤ) - (j : ℤ))) else 0

/-- The self-contained definition above is definitionally the project's `nnDist`. -/
theorem supNN_eq {d : ℕ} (α : Fin d → ℝ) (N q : ℕ) :
    supNN α N q = ThreeGap.DeltaCost.nnDist α N q := rfl

/-- **g_∞ ≤ 2^d + 1.** At most `2^d + 1` distinct sup-norm nearest-neighbour distances. -/
theorem supnorm_count_le {d : ℕ} (α : Fin d → ℝ) {k₀ : Fin d} (hirr : Irrational (α k₀))
    {N : ℕ} (hN : 2 ≤ N) : ((range (N + 1)).image (supNN α N)).card ≤ 2 ^ d + 1 :=
  ThreeGap.SimDirichlet.nnDist_count_unconditional α hirr hN

/-- **g_∞(3) = 9 is attained.** An explicit `α` (with irrational coordinate) and `N` realizing
exactly 9 distinct sup-norm nearest-neighbour distances on `𝕋³`. -/
theorem nine_attained_spec :
    ∃ α : Fin 3 → ℝ, (∃ k, Irrational (α k)) ∧
      ∃ N, 2 ≤ N ∧ ((range (N + 1)).image (supNN α N)).card = 9 := by
  obtain ⟨α, hirr, N, hN, hge⟩ := ThreeGap.LinftyRecords3.nine_attained
  exact ⟨α, hirr, N, hN, le_antisymm
    (le_trans (ThreeGap.SimDirichlet.nnDist_count_unconditional α hirr.choose_spec hN)
      (by norm_num)) hge⟩

end FiveDistanceSpec
