/-
Copyright (c) 2026 Vico Bonfioli. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: Vico Bonfioli
-/
/-
# The Euclidean approximation defect is attained (the nearest lattice point exists)

`euclidean_growth_five` consumes the hypothesis `hattain` — that each remainder norm equals the defect
`δ_q`. For the **sup** norm this came from coordinatewise rounding (`DeltaCost.delta_attained`); for
the **Euclidean** norm the nearest lattice point is *not* coordinatewise, so attainment is a genuine
(finite) minimization: among the integer translates with norm `≤ V` (an explicit upper bound from
rounding) only finitely many `p` survive (each coordinate is confined to an interval), and the minimum
over that finite set realises the infimum.

`deltaN_euclNorm_attained`: `∃ p, euclNorm n (rem α q p) = δ_q`. Axiom-clean.
-/

import ThreeGap.EuclideanGrowthFive
import ThreeGap.DeltaCost

namespace ThreeGap.SimApprox

open scoped BigOperators

variable {n : ℕ}

/-- The Euclidean norm on `Fin n → ℝ` as a square root of a sum of squares. -/
theorem euclNorm_eq (x : Fin n → ℝ) : euclNorm n x = Real.sqrt (∑ i, (x i) ^ 2) := by
  unfold euclNorm
  rw [EuclideanSpace.norm_eq]
  congr 1
  refine Finset.sum_congr rfl (fun i _ => ?_)
  rw [Real.norm_eq_abs, sq_abs]
  rfl

/-- Each coordinate is bounded by the Euclidean norm: `|x k| ≤ euclNorm n x`. -/
theorem abs_le_euclNorm (x : Fin n → ℝ) (k : Fin n) : |x k| ≤ euclNorm n x := by
  rw [euclNorm_eq, ← Real.sqrt_sq (abs_nonneg (x k)), sq_abs]
  exact Real.sqrt_le_sqrt (Finset.single_le_sum (fun i _ => sq_nonneg (x i)) (Finset.mem_univ k))

/-- **The Euclidean defect is attained.** For every denominator `q` there is an integer translate `p`
with `euclNorm n (rem α q p) = δ_q` (the nearest lattice point to `q • α`). -/
theorem deltaN_euclNorm_attained (α : Fin n → ℝ) (q : ℤ) :
    ∃ p : Fin n → ℤ, euclNorm n (rem α q p) = deltaN (euclNorm n) α q := by
  classical
  -- an explicit upper bound, from coordinatewise rounding
  set p₀ : Fin n → ℤ := fun k => round ((q : ℝ) * α k) with hp₀
  set V : ℝ := euclNorm n (rem α q p₀) with hV
  -- the candidate set: integer translates with norm ≤ V
  set S : Set (Fin n → ℤ) := {p | euclNorm n (rem α q p) ≤ V} with hS
  have hp₀S : p₀ ∈ S := by simp only [hS, Set.mem_setOf_eq]; exact le_of_eq hV.symm
  -- finiteness: each coordinate is confined to an interval of length `2V`
  have hSfin : S.Finite := by
    apply Set.Finite.subset
      (Set.Finite.pi (fun k => Set.finite_Icc (⌈(q : ℝ) * α k - V⌉) (⌊(q : ℝ) * α k + V⌋)))
    intro p hp
    simp only [hS, Set.mem_setOf_eq] at hp
    simp only [Set.mem_pi, Set.mem_univ, Set.mem_Icc, forall_true_left]
    intro k
    have hcoord : |(rem α q p) k| ≤ V := le_trans (abs_le_euclNorm _ k) hp
    have hrem : (rem α q p) k = (q : ℝ) * α k - (p k : ℝ) := by
      simp only [rem, Pi.sub_apply, Pi.smul_apply, smul_eq_mul]
    rw [hrem, abs_le] at hcoord
    constructor
    · exact Int.ceil_le.mpr (by linarith [hcoord.1])
    · exact Int.le_floor.mpr (by linarith [hcoord.2])
  -- the minimum over the finite candidate set
  obtain ⟨p₁, hp₁mem, hp₁min⟩ :=
    hSfin.toFinset.exists_min_image (fun p => euclNorm n (rem α q p))
      ⟨p₀, hSfin.mem_toFinset.mpr hp₀S⟩
  rw [hSfin.mem_toFinset] at hp₁mem
  have hp₁V : euclNorm n (rem α q p₁) ≤ V := hp₁mem
  -- `p₁` minimises over *all* translates: in `S` by minimality, outside `S` by the bound `> V`
  have hall : ∀ p, euclNorm n (rem α q p₁) ≤ euclNorm n (rem α q p) := by
    intro p
    by_cases hp : p ∈ S
    · exact hp₁min p (hSfin.mem_toFinset.mpr hp)
    · simp only [hS, Set.mem_setOf_eq, not_le] at hp
      linarith [hp₁V, hp]
  refine ⟨p₁, le_antisymm ?_ (deltaN_le (euclNorm n) euclNorm_nonneg α q p₁)⟩
  exact le_ciInf hall

end ThreeGap.SimApprox