import Mathlib
import ThreeGap
open Finset

/-! Proofs of the `Challenge.lean` statements from the project's theorems. The definitions below are
identical (definitionally) to the project's `nnDist`, so the project's theorems prove these directly. -/

namespace FiveDistanceSpec

noncomputable def supDelta {n : ℕ} (α : Fin n → ℝ) (q : ℤ) : ℝ :=
  ⨅ p : Fin n → ℤ, ‖(q : ℝ) • α - (fun k => (p k : ℝ))‖

noncomputable def supNN {d : ℕ} (α : Fin d → ℝ) (N q : ℕ) : ℝ :=
  if h : ((range (N + 1)).erase q).Nonempty then
    ((range (N + 1)).erase q).inf' h (fun j => supDelta α ((q : ℤ) - (j : ℤ))) else 0

/-- `supNN` is definitionally the project's `nnDist`. -/
theorem supNN_eq {d : ℕ} (α : Fin d → ℝ) (N q : ℕ) :
    supNN α N q = ThreeGap.DeltaCost.nnDist α N q := rfl

theorem supnorm_count_le {d : ℕ} (α : Fin d → ℝ) {k₀ : Fin d} (hirr : Irrational (α k₀))
    {N : ℕ} (hN : 2 ≤ N) : ((range (N + 1)).image (supNN α N)).card ≤ 2 ^ d + 1 :=
  ThreeGap.SimDirichlet.nnDist_count_unconditional α hirr hN

theorem nine_attained_spec :
    ∃ α : Fin 3 → ℝ, (∃ k, Irrational (α k)) ∧
      ∃ N, 2 ≤ N ∧ ((range (N + 1)).image (supNN α N)).card = 9 := by
  obtain ⟨α, hirr, N, hN, hge⟩ := ThreeGap.LinftyRecords3.nine_attained
  exact ⟨α, hirr, N, hN, le_antisymm
    (le_trans (ThreeGap.SimDirichlet.nnDist_count_unconditional α hirr.choose_spec hN)
      (by norm_num)) hge⟩

end FiveDistanceSpec
