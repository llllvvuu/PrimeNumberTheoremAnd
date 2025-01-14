import PrimeNumberTheoremAnd.ResidueCalcOnRectangles
import PrimeNumberTheoremAnd.Wiener
import Mathlib.Analysis.Calculus.ContDiff.Basic

open Complex Topology Filter

/-%%
In this section, we define the Mellin transform (already in Mathlib, thanks to David Loeffler), prove its inversion formula, and
derive a number of important properties of some special functions and bumpfunctions.

Def: (Already in Mathlib)
Let $f$ be a function from $\mathbb{R}_{>0}$ to $\mathbb{C}$. We define the Mellin transform of $f$ to be the function $\mathcal{M}(f)$ from $\mathbb{C}$ to $\mathbb{C}$ defined by
$$\mathcal{M}(f)(s) = \int_0^\infty f(x)x^{s-1}dx.$$

[Note: My preferred way to think about this is that we are integrating over the multiplicative group $\mathbb{R}_{>0}$, multiplying by a (not necessarily unitary!) character $|\cdot|^s$, and integrating with respect to the invariant Haar measure $dx/x$. This is very useful in the kinds of calculations carried out below. But may be more difficult to formalize as things now stand. So we
might have clunkier calculations, which ``magically'' turn out just right - of course they're explained by the aforementioned structure...]

%%-/


/-%%
It is very convenient to define integrals along vertical lines in the complex plane, as follows.
\begin{definition}\label{VerticalIntegral}\leanok
Let $f$ be a function from $\mathbb{C}$ to $\mathbb{C}$, and let $\sigma$ be a real number. Then we define
$$\int_{(\sigma)}f(s)ds = \int_{\sigma-i\infty}^{\sigma+i\infty}f(s)ds.$$
\end{definition}
[Note: Better to define $\int_{(\sigma)}$ as $\frac1{2\pi i}\int_{\sigma-i\infty}^{\sigma+i\infty}$??
There's a factor of $2\pi i$ in such contour integrals...]
%%-/

noncomputable def VerticalIntegral (f : ℂ → ℂ) (σ : ℝ) : ℂ :=
  I • ∫ t : ℝ, f (σ + t * I)


/-%%
The following is preparatory material used in the proof of the Perron formula, see Lemma \ref{PerronFormula}.
%%-/

/-%%
\begin{lemma}\label{zeroTendstoDiff}\lean{zeroTendstoDiff}\leanok
If the limit of $0$ is $L₁ - L₂$, then $L₁ = L₂$.
\end{lemma}
%%-/
lemma zeroTendstoDiff (L₁ L₂ : ℂ) (f : ℝ → ℂ) (h : ∀ᶠ T in atTop,  f T = 0)
    (h' : Tendsto f atTop (𝓝 (L₂ - L₁))) : L₁ = L₂ := by
  sorry
/-%%
\begin{proof}
Obvious.
\end{proof}
%%-/


/-%%
\begin{lemma}\label{HolomorphicOn_of_Perron_function}\lean{HolomorphicOn_of_Perron_function}\leanok
Let $x>0$. Then the function $f(s) = x^s/(s(s+1))$ is holomorphic on the half-plane $\{s\in\mathbb{C}:\Re(s)>0\}$.
\end{lemma}
%%-/
lemma HolomorphicOn_of_Perron_function {x : ℝ} (xpos : 0 < x) :
    HolomorphicOn (fun s => x ^ s / (s * (s + 1))) {s | 0 < s.re} := by
  sorry
/-%%
\begin{proof}
Composition of differentiabilities.
\end{proof}
%%-/

/-%%
\begin{lemma}\label{RectangleIntegral_eq_zero}\lean{RectangleIntegral_eq_zero}\leanok
\uses{RectangleIntegral}
Let $\sigma,\sigma',T>0$, and let $f$ be a holomorphic function on the half-plane $\{s\in\mathbb{C}:\Re(s)>0\}$. Then
the rectangle integral
$$\int_{\sigma-iT}^{\sigma'+iT}f(s)ds = 0.$$
\end{lemma}
%%-/
lemma RectangleIntegral_eq_zero {σ σ' T : ℝ} (σ_pos : 0 < σ) (σ'_pos : 0 < σ') (T_pos : 0 < T)
    {f : ℂ → ℂ} (fHolo : HolomorphicOn f {s | 0 < s.re}) :
    RectangleIntegral f (σ - I * T) (σ' + I * T) = 0 := by
  sorry -- apply HolomorphicOn.vanishesOnRectangle in PR #9598
/-%%
\begin{proof}
This almost exists in a Mathlib PR, needs to be adapted here.
(HolomorphicOn.vanishesOnRectangle in PR \#9598)
\end{proof}
%%-/


/-%%
\begin{lemma}\label{RectangleIntegral_tendsTo_VerticalIntegral}\lean{RectangleIntegral_tendsTo_VerticalIntegral}\leanok
\uses{RectangleIntegral}
Let $\sigma,\sigma'>0$, and let $f$ be a holomorphic function on the half-plane $\{s\in\mathbb{C}:\Re(s)>0\}$. Then
the limit of rectangle integrals
$$\lim_{T\to\infty}\int_{\sigma-iT}^{\sigma'+iT}f(s)ds = \int_{(\sigma')}f(s)ds - \int_{(\sigma)}f(s)ds
.$$
*** Needs more conditions on $f$ ***
\end{lemma}
%%-/

lemma RectangleIntegral_tendsTo_VerticalIntegral {σ σ' : ℝ} (σ_pos : 0 < σ) (σ'_pos : 0 < σ')
    {f : ℂ → ℂ} (fHolo : HolomorphicOn f {s | 0 < s.re}) :
    -- needs more hypotheses
    Tendsto (fun (T : ℝ) ↦ RectangleIntegral f (σ - I * T) (σ' + I * T)) atTop
      (𝓝 (VerticalIntegral f σ' - VerticalIntegral f σ)) := by
  sorry
/-%%
\begin{proof}
Almost by definition.
\end{proof}
%%-/


/-%%
\begin{lemma}\label{PerronIntegralPosAux}\lean{PerronIntegralPosAux}\leanok
The integral
$$\int_\R\frac{1}{|(1+t^2)(2+t^2)|^{1/2}}dt$$
is positive (and hence convergent - since a divergent integral is zero in Lean, by definition).
\end{lemma}
%%-/
lemma PerronIntegralPosAux : 0 < ∫ (t : ℝ), 1 / |Real.sqrt (1 + t^2) * Real.sqrt (2 + t^2)| := by
  sorry
/-%%
\begin{proof}
Standard estimate.
\end{proof}
%%-/

/-%%
\begin{lemma}\label{VertIntPerronBound}\lean{VertIntPerronBound}\leanok
\uses{VerticalIntegral}
Let $x>0$, $\sigma>1$, and $x<1$. Then
$$\left|
\int_{(\sigma)}\frac{x^s}{s(s+1)}ds\right| \leq x^\sigma \int_\R\frac{1}{|(1+t^2)(2+t^2)|^{1/2}}dt.$$
\end{lemma}
%%-/

lemma VertIntPerronBound {x : ℝ} (xpos : 0 < x) (x_le_one : x < 1) {σ : ℝ} (σ_gt_one : 1 < σ) :
    Complex.abs (VerticalIntegral (fun s ↦ x^s / (s * (s + 1))) σ)
      ≤ x ^ σ * ∫ (t : ℝ), 1 / |Real.sqrt (1 + t^2) * Real.sqrt (2 + t^2)| := by
  sorry
/-%%
\begin{proof}
Triangle inequality and pointwise estimate.
\end{proof}
%%-/

/-%%
\begin{lemma}\label{limitOfConstant}\lean{limitOfConstant}\leanok
Let $a:\R\to\C$ be a function, and let $\sigma>0$ be a real number. Suppose that, for all
$\sigma, \sigma'>0$, we have $a(\sigma')=a(\sigma)$, and that
$\lim_{\sigma\to\infty}a(\sigma)=0$. Then $a(\sigma)=0$.
\end{lemma}
%%-/
lemma limitOfConstant {a : ℝ → ℂ} {σ : ℝ} (σpos : 0 < σ) (ha : ∀ (σ' : ℝ) (σ'' : ℝ) (σ'pos : 0 < σ')
    (σ''pos : 0 < σ''), a σ' = a σ'') (ha' : Tendsto (fun σ' => a σ') atTop (𝓝 0)) : a σ = 0 := by
  sorry
/-%%
\begin{proof}
To show that $a(\sigma)=0$, we show that $a(\sigma)< \epsilon$ for all $\epsilon>0$. Let $\epsilon>0$.
The fact that $\lim_{\sigma\to\infty}a(\sigma)=0$ means that there exists $\sigma_0>0$ such that
$|a(\sigma)|<\epsilon$ for all $\sigma>\sigma_0$. Now let $\sigma>0$. Then $a(\sigma)=a(\sigma_0)$, and
so $|a(\sigma)|=|a(\sigma_0)|<\epsilon$, as required.
\end{proof}
%%-/

/-%%
\begin{lemma}\label{tendsto_Realpow_atTop_nhds_0_of_norm_lt_1}\lean{tendsto_Realpow_atTop_nhds_0_of_norm_lt_1}\leanok
Let $x>0$ and $x<1$. Then
$$\lim_{\sigma\to\infty}x^\sigma=0.$$
\end{lemma}
%%-/
lemma tendsto_Realpow_atTop_nhds_0_of_norm_lt_1 {x : ℝ} {C : ℝ} (xpos : 0 < x) (x_lt_one : x < 1) (Cpos : C > 0) :
  Tendsto (fun (σ : ℝ) => x ^ σ * C) atTop (𝓝 0) := by
  sorry -- mimic `tendsto_pow_atTop_nhds_0_of_norm_lt_1`
/-%%
\begin{proof}
Standard.
\end{proof}
%%-/

/-%%
We are ready for the Perron formula, which breaks into two cases, the first being:
\begin{lemma}\label{PerronFormulaLtOne}\lean{VerticalIntegral_Perron_lt_one}\leanok
For $x>0$, $\sigma>0$, and $x<1$, we have
$$
\frac1{2\pi i}
\int_{(\sigma)}\frac{x^s}{s(s+1)}ds =0.
$$
\end{lemma}
%%-/

lemma VerticalIntegral_Perron_lt_one {x : ℝ}  (xpos : 0 < x) (x_lt_one : x < 1)
    {σ : ℝ} (σ_pos : 0 < σ) : VerticalIntegral (fun s ↦ x^s / (s * (s + 1))) σ = 0 := by
/-%%
\begin{proof}
\uses{HolomorphicOn_of_Perron_function, RectangleIntegral_eq_zero, PerronIntegralPosAux,
VertIntPerronBound, limitOfConstant, RectangleIntegral_tendsTo_VerticalIntegral, zeroTendstoDiff,
tendsto_Realpow_atTop_nhds_0_of_norm_lt_1}
\leanok
  Let $f(s) = x^s/(s(s+1))$. Then $f$ is holomorphic on the half-plane $\{s\in\mathbb{C}:\Re(s)>0\}$.
%%-/
  set f : ℂ → ℂ := (fun s ↦ x^s / (s * (s + 1)))
  have fHolo : HolomorphicOn f {s : ℂ | 0 < s.re} := HolomorphicOn_of_Perron_function xpos
--%% The rectangle integral of $f$ with corners $\sigma-iT$ and $\sigma+iT$ is zero.
  have rectInt : ∀ (σ' σ'' : ℝ) (σ'pos : 0 < σ') (σ''pos : 0 < σ'') (T : ℝ) (Tpos : 0 < T),
    RectangleIntegral f (σ' - I * T) (σ'' + I * T) = 0 :=
    fun σ' σ'' σ'pos σ''pos T Tpos ↦ RectangleIntegral_eq_zero σ'pos σ''pos Tpos fHolo
--%% The limit of this rectangle integral as $T\to\infty$ is $\int_{(\sigma')}-\int_{(\sigma)}$.
  have rectIntLimit : ∀ (σ' σ'' : ℝ) (σ'pos : 0 < σ') (σ''pos : 0 < σ''),
    Tendsto (fun (T : ℝ) ↦ RectangleIntegral f (σ' - I * T) (σ'' + I * T))
      atTop (𝓝 (VerticalIntegral f σ'' - VerticalIntegral f σ')) := fun σ' σ'' σ'pos σ''pos ↦
      RectangleIntegral_tendsTo_VerticalIntegral σ'pos σ''pos fHolo
--%% Therefore, $\int_{(\sigma')}=\int_{(\sigma)}$.
  have contourPull : ∀ (σ' σ'' : ℝ) (σ'pos : 0 < σ') (σ''pos : 0 < σ''),
    VerticalIntegral f σ' = VerticalIntegral f σ''
  · intro σ' σ'' σ'pos σ''pos
    refine zeroTendstoDiff (VerticalIntegral f σ') (VerticalIntegral f σ'') ((fun T => RectangleIntegral f (↑σ' - I * ↑T) (↑σ'' + I * ↑T))) ?_ ?_
    · filter_upwards [eventually_gt_atTop 0]
      exact (rectInt σ' σ'' σ'pos σ''pos)
    · exact (rectIntLimit σ' σ'' σ'pos σ''pos)
--%% But we also have the bound $\int_{(\sigma')} \leq x^{\sigma'} * C$, where
--%% $C=\int_\R\frac{1}{|(1+t)(1+t+1)|}dt$.
  have VertIntBound : ∃ C > 0, ∀ σ' > 1, Complex.abs (VerticalIntegral f σ') ≤ x^σ' * C
  · let C := ∫ (t : ℝ), 1 / |Real.sqrt (1 + t^2) * Real.sqrt (2 + t^2)|
    refine ⟨C, PerronIntegralPosAux, fun σ' σ'_gt_one ↦ VertIntPerronBound xpos x_lt_one σ'_gt_one⟩
--%% Therefore $\int_{(\sigma')}\to 0$ as $\sigma'\to\infty$.
  have AbsVertIntTendsto : Tendsto (fun (σ' : ℝ) ↦ Complex.abs (VerticalIntegral f σ')) atTop (𝓝 0)
  · obtain ⟨C, Cpos, hC⟩ := VertIntBound
    have := tendsto_Realpow_atTop_nhds_0_of_norm_lt_1 xpos x_lt_one Cpos
    refine tendsto_of_tendsto_of_tendsto_of_le_of_le'
      (f := (fun (σ' : ℝ) ↦ Complex.abs (VerticalIntegral f σ'))) (a := 0) (g := fun x ↦ 0)
      (h := (fun σ => x ^ σ * C)) (b := atTop) (tendsto_const_nhds) this ?_ ?_
    · filter_upwards; exact fun _ ↦ Complex.abs.nonneg' _
    · filter_upwards [eventually_gt_atTop 1]; exact fun σ' σ'_gt_one ↦ hC σ' σ'_gt_one
  have VertIntTendsto : Tendsto (fun (σ' : ℝ) ↦ VerticalIntegral f σ') atTop (𝓝 0) :=
    tendsto_zero_iff_norm_tendsto_zero.mpr AbsVertIntTendsto
  --%% So pulling contours gives $\int_{(\sigma)}=0$.
  exact limitOfConstant (a := fun σ' ↦ VerticalIntegral f σ') σ_pos contourPull VertIntTendsto
--%%\end{proof}


/-%%
The second lemma is the case $x>1$.
\begin{lemma}\label{PerronFormulaGtOne}\lean{VerticalIntegral_Perron_gt_one}\leanok
For $x>1$ and $\sigma>0$, we have
$$
\frac1{2\pi i}
\int_{(\sigma)}\frac{x^s}{s(s+1)}ds =1-1/x.
$$
\end{lemma}
%%-/

lemma VerticalIntegral_Perron_gt_one {x : ℝ} (x_gt_one : 1 < x) {σ : ℝ} (σ_pos : 0 < σ) :
    VerticalIntegral (fun s ↦ x^s / (s * (s + 1))) σ = 1 - 1 / x := by
  sorry

/-%%
\begin{proof}
Similar, but now we actually have to pull contours and pick up residues.
\end{proof}
%%-/


/-%%
The two together give the Perron formula.
\begin{lemma}\label{PerronFormula}
\uses{PerronFormulaLtOne, PerronFormulaGtOne}
For $x>0$ and $\sigma>0$, we have
$$
\frac1{2\pi i}
\int_{(\sigma)}\frac{x^s}{s(s+1)}ds = \begin{cases}
1-\frac1x & \text{ if }x>1\\
0 & \text{ if } x<1
\end{cases}.
$$
\end{lemma}
%%-/

/-%%
\begin{theorem}\label{MellinInversion}
Let $f$ be a nice function from $\mathbb{R}_{>0}$ to $\mathbb{C}$, and let $\sigma$ be sufficiently large. Then
$$f(x) = \frac{1}{2\pi i}\int_{(\sigma)}\mathcal{M}(f)(s)x^{-s}ds.$$
\end{theorem}

[Note: How ``nice''? Schwartz (on $(0,\infty)$) is certainly enough. As we formalize this, we can add whatever conditions are necessary for the proof to go through.]
%%-/
/-%%
\begin{proof}
\uses{PerronFormula, MellinTransform}
The proof is from [Goldfeld-Kontorovich 2012].
Integrate by parts twice.
$$
\mathcal{M}(f)(s) = \int_0^\infty f(x)x^{s-1}dx = - \int_0^\infty f'(x)x^s\frac{1}{s}dx = \int_0^\infty f''(x)x^{s+1}\frac{1}{s(s+1)}dx.
$$
Assuming $f$ is Schwartz, say, we now have at least quadratic decay in $s$ of the Mellin transform. Inserting this formula into the inversion formula and Fubini-Tonelli (we now have absolute convergence!) gives:
$$
RHS = \frac{1}{2\pi i}\left(\int_{(\sigma)}\int_0^\infty f''(t)t^{s+1}\frac{1}{s(s+1)}dt\right) x^{-s}ds
$$
$$
= \int_0^\infty f''(t) t \left( \frac{1}{2\pi i}\int_{(\sigma)}(t/x)^s\frac{1}{s(s+1)}ds\right) dt.
$$
Apply the Perron formula to the inside:
$$
= \int_x^\infty f''(t) t \left(1-\frac{x}{t}\right)dt
= -\int_x^\infty f'(t) dt
= f(x),
$$
where we integrated by parts (undoing the first partial integration), and finally applied the fundamental theorem of calculus (undoing the second).
\end{proof}
%%-/

/-%%
Finally, we need Mellin Convolutions and properties thereof.
\begin{definition}\label{MellinConvolution}
Let $f$ and $g$ be functions from $\mathbb{R}_{>0}$ to $\mathbb{C}$. Then we define the Mellin convolution of $f$ and $g$ to be the function $f\ast g$ from $\mathbb{R}_{>0}$ to $\mathbb{C}$ defined by
$$(f\ast g)(x) = \int_0^\infty f(y)g(x/y)\frac{dy}{y}.$$
\end{definition}
%%-/

/-%%
The Mellin transform of a convolution is the product of the Mellin transforms.
\begin{theorem}\label{MellinConvolutionTransform}
Let $f$ and $g$ be functions from $\mathbb{R}_{>0}$ to $\mathbb{C}$. Then
$$\mathcal{M}(f\ast g)(s) = \mathcal{M}(f)(s)\mathcal{M}(g)(s).$$
\end{theorem}
%%-/

/-%%
\begin{proof}
\uses{MellinTransform}
This is a straightforward calculation.
\end{proof}
%%-/

lemma Function.support_id : Function.support (fun x : ℝ => x) = Set.Iio 0 ∪ Set.Ioi 0 := by
  ext x
  simp only [mem_support, ne_eq, Set.Iio_union_Ioi, Set.mem_compl_iff, Set.mem_singleton_iff]

attribute [- simp] one_div

/-%%
Let $\psi$ be a bumpfunction.
\begin{theorem}\label{SmoothExistence}\leanok
There exists a smooth (once differentiable would be enough), nonnegative ``bumpfunction'' $\psi$,
 supported in $[1/2,2]$ with total mass one:
$$
\int_0^\infty \psi(x)\frac{dx}{x} = 1.
$$
\end{theorem}
%%-/

lemma SmoothExistence : ∃ (Ψ : ℝ → ℝ), (∀ n, ContDiff ℝ n Ψ) ∧ Ψ.support ⊆ Set.Icc (1 / 2) 2 ∧ ∫ x in Set.Ici 0, Ψ x / x = 1 := by
  suffices h : ∃ (Ψ : ℝ → ℝ), (∀ n, ContDiff ℝ n Ψ) ∧ Ψ.support ⊆ Set.Icc (1 / 2) 2 ∧ 0 < ∫ x in Set.Ici 0, Ψ x / x
  · rcases h with ⟨Ψ, hΨ, hΨsupp, hΨpos⟩
    let c := (∫ x in Set.Ici 0, Ψ x / x)
    use fun y => Ψ y / c
    constructor
    · intro n
      exact ContDiff.div_const (hΨ n) c
    · constructor
      · simp only [Function.support, Set.subset_def, div_ne_zero] at hΨsupp ⊢
        intro y hy
        have := hΨsupp y
        apply this
        simp at hy
        push_neg at hy
        simp [hy.left]
      · simp only [div_right_comm _ c _]
        rw [MeasureTheory.integral_div c]
        apply div_self
        exact ne_of_gt hΨpos
  have := smooth_urysohn_support_Ioo (a := 1 / 2) (b := 1) (c := 3/2) (d := 2) (by linarith) (by linarith) (by linarith)
  rcases this with ⟨Ψ, hΨContDiff, _, hΨ0, hΨ1, hΨSupport⟩
  use Ψ
  use hΨContDiff
  unfold Set.indicator at hΨ0 hΨ1
  simp only [Set.mem_Icc, Pi.one_apply, Pi.le_def, Set.mem_Ioo] at hΨ0 hΨ1
  constructor
  · simp only [hΨSupport, Set.subset_def, Set.mem_Ioo, Set.mem_Icc, and_imp]
    intro y hy hy'
    exact ⟨by linarith, by linarith⟩
  · rw [MeasureTheory.integral_pos_iff_support_of_nonneg]
    · simp only [Function.support_div, measurableSet_Ici, MeasureTheory.Measure.restrict_apply']
      rw [hΨSupport]
      rw [Function.support_id]
      have : (Set.Ioo (1 / 2 : ℝ) 2 ∩ (Set.Iio 0 ∪ Set.Ioi 0) ∩ Set.Ici 0) = Set.Ioo (1 / 2) 2 := by
        ext x
        simp only [Set.mem_inter_iff, Set.mem_Ioo, Set.mem_Ici, Set.mem_Iio, Set.mem_Ioi, Set.mem_union, not_lt, and_true, not_le]
        constructor
        · intros h
          exact h.left.left
        · intros h
          simp [h, and_true, lt_or_lt_iff_ne, ne_eq]
          constructor
          · linarith [h.left]
          · linarith
      simp only [this, Real.volume_Ioo, ENNReal.ofReal_pos, sub_pos, gt_iff_lt]
      linarith
    · rw [Pi.le_def]
      intro y
      simp only [Pi.zero_apply]
      by_cases h : y ∈ Function.support Ψ
      . apply div_nonneg
        · apply le_trans _ (hΨ0 y)
          simp [apply_ite]
        rw [hΨSupport, Set.mem_Ioo] at h
        linarith [h.left]
      . simp only [Function.mem_support, ne_eq, not_not] at h
        simp [h]
    · have : (fun x => Ψ x / x) = Set.piecewise (Set.Icc (1 / 2) 2) (fun x => Ψ x / x) 0 := by
        ext x
        simp only [Set.piecewise]
        by_cases hxIcc : x ∈ Set.Icc (1 / 2) 2
        · exact (if_pos hxIcc).symm
        · rw [if_neg hxIcc]
          have hΨx0 : Ψ x = 0 := by
            have hxIoo : x ∉ Set.Ioo (1 / 2) 2 := by
              simp only [Set.mem_Icc, not_and_or, not_le] at hxIcc
              simp [Set.mem_Ioo, Set.mem_Icc]
              intro
              cases hxIcc <;> linarith
            rw [<-hΨSupport] at hxIoo
            simp only [Function.mem_support, ne_eq, not_not] at hxIoo
            exact hxIoo
          simp [hΨx0]
      rw [this]
      apply MeasureTheory.Integrable.piecewise measurableSet_Icc
      · apply ContinuousOn.integrableOn_compact isCompact_Icc
        apply ContinuousOn.div
        · replace hΨContDiff := hΨContDiff 0
          simp only [contDiff_zero] at hΨContDiff
          exact Continuous.continuousOn hΨContDiff
        · apply continuousOn_id
        · simp only [Set.mem_Icc, ne_eq, and_imp]
          intros
          linarith
      · -- exact? -- fails
        exact MeasureTheory.integrableOn_zero


/-%%
\begin{proof}\leanok
\uses{smooth-ury}
Same idea as Urysohn-type argument.
\end{proof}
%%-/

/-%%
The $\psi$ function has Mellin transform $\mathcal{M}(\psi)(s)$ which is entire and decays (at least) like $1/|s|$.
\begin{theorem}\label{MellinOfPsi}
The Mellin transform of $\psi$ is
$$\mathcal{M}(\psi)(s) =  O\left(\frac{1}{|s|}\right),$$
as $|s|\to\infty$.
\end{theorem}

[Of course it decays faster than any power of $|s|$, but it turns out that we will just need one power.]
%%-/

/-%%
\begin{proof}
\uses{MellinTransform, SmoothExistence}
Integrate by parts once.
\end{proof}
%%-/

/-%%
We can make a delta spike out of this bumpfunction, as follows.
\begin{definition}\label{DeltaSpike}
\uses{SmoothExistence}
Let $\psi$ be a bumpfunction supported in $[1/2,2]$. Then for any $\epsilon>0$, we define the delta spike $\psi_\epsilon$ to be the function from $\mathbb{R}_{>0}$ to $\mathbb{C}$ defined by
$$\psi_\epsilon(x) = \frac{1}{\epsilon}\psi\left(x^{\frac{1}{\epsilon}}\right).$$
\end{definition}

This spike still has mass one:
\begin{lemma}\label{DeltaSpikeMass}
For any $\epsilon>0$, we have
$$\int_0^\infty \psi_\epsilon(x)\frac{dx}{x} = 1.$$
\end{lemma}
%%-/
/-%%
\begin{proof}
\uses{DeltaSpike}
Substitute $y=x^{1/\epsilon}$, and use the fact that $\psi$ has mass one, and that $dx/x$ is Haar measure.
\end{proof}
%%-/

/-%%
The Mellin transform of the delta spike is easy to compute.
\begin{theorem}\label{MellinOfDeltaSpike}
For any $\epsilon>0$, the Mellin transform of $\psi_\epsilon$ is
$$\mathcal{M}(\psi_\epsilon)(s) = \mathcal{M}(\psi)\left(\epsilon s\right).$$
\end{theorem}
%%-/

/-%%
\begin{proof}
\uses{DeltaSpike, MellinTransform}
Substitute $y=x^{1/\epsilon}$, use Haar measure; direct calculation.
\end{proof}
%%-/

/-%%
In particular, for $s=1$, we have that the Mellin transform of $\psi_\epsilon$ is $1+O(\epsilon)$.
\begin{corollary}\label{MellinOfDeltaSpikeAt1}
For any $\epsilon>0$, we have
$$\mathcal{M}(\psi_\epsilon)(1) =
\mathcal{M}(\psi)(\epsilon)= 1+O(\epsilon).$$
\end{corollary}
%%-/

/-%%
\begin{proof}
\uses{MellinOfDeltaSpike, DeltaSpikeMass}
This is immediate from the above theorem, the fact that $\mathcal{M}(\psi)(0)=1$ (total mass one),
and that $\psi$ is Lipschitz.
\end{proof}
%%-/

/-%%
Let $1_{(0,1]}$ be the function from $\mathbb{R}_{>0}$ to $\mathbb{C}$ defined by
$$1_{(0,1]}(x) = \begin{cases}
1 & \text{ if }x\leq 1\\
0 & \text{ if }x>1
\end{cases}.$$
This has Mellin transform
\begin{theorem}\label{MellinOf1}
The Mellin transform of $1_{(0,1]}$ is
$$\mathcal{M}(1_{(0,1]})(s) = \frac{1}{s}.$$
\end{theorem}
[Note: this already exists in mathlib]
%%-/

/-%%
What will be essential for us is properties of the smooth version of $1_{(0,1]}$, obtained as the
 Mellin convolution of $1_{(0,1]}$ with $\psi_\epsilon$.
\begin{definition}\label{Smooth1}\uses{MellinOf1, MellinConvolution}
Let $\epsilon>0$. Then we define the smooth function $\widetilde{1_{\epsilon}}$ from $\mathbb{R}_{>0}$ to $\mathbb{C}$ by
$$\widetilde{1_{\epsilon}} = 1_{(0,1]}\ast\psi_\epsilon.$$
\end{definition}
%%-/

/-%%
In particular, we have the following
\begin{lemma}\label{Smooth1Properties}
Fix $\epsilon>0$. There is an absolute constant $c>0$ so that:

(1) If $x\leq (1-c\epsilon)$, then
$$\widetilde{1_{\epsilon}}(x) = 1.$$

And (2):
if $x\geq (1+c\epsilon)$, then
$$\widetilde{1_{\epsilon}}(x) = 0.$$
\end{lemma}
%%-/

/-%%
\begin{proof}
\uses{Smooth1, MellinConvolution}
This is a straightforward calculation, using the fact that $\psi_\epsilon$ is supported in $[1/2^\epsilon,2^\epsilon]$.
\end{proof}
%%-/

/-%%
Combining the above, we have the following Main Lemma of this section on the Mellin transform of $\widetilde{1_{\epsilon}}$.
\begin{lemma}\label{MellinOfSmooth1}\uses{Smooth1Properties, MellinConvolutionTransform, MellinOfDeltaSpikeAt1, MellinOfPsi}
Fix  $\epsilon>0$. Then the Mellin transform of $\widetilde{1_{\epsilon}}$ is
$$\mathcal{M}(\widetilde{1_{\epsilon}})(s) = \frac{1}{s}\left(\mathcal{M}(\psi)\left(\epsilon s\right)\right).$$

For any $s$, we have the bound
$$\mathcal{M}(\widetilde{1_{\epsilon}})(s) = O\left(\frac{1}{\epsilon|s|^2}\right).$$

At $s=1$, we have
$$\mathcal{M}(\widetilde{1_{\epsilon}})(1) = (1+O(\epsilon)).$$
\end{lemma}
%%-/
