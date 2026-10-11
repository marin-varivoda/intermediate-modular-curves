# Upper bounds on gon_Q for all 76 strict X_Δ(N), N ≤ 50

**Result.** `upper_bounds.csv` gives an upper bound for every curve, with one source per curve.
Every bound equals the proved gonality, so each is sharp.

| Method | Curves | Argument |
|---|---:|---|
| `cited` | 41 | Orlić, Thm 1.2 (Table 1) for N ≤ 40 and genus ≥ 3 (39 curves); Orlić, Thm 1.5 for `44.144.8.c.4`; Orlić, Thm 1.3 for `45.144.5.a.1` |
| `genus` | 14 | A rational cusp gives a pencil: genus 0 → 1, genus 1–2 → 2, genus 3 non-hyperelliptic → 3 (projection from the cusp) |
| `pullback` | 14 | gon_Q(X) ≤ deg(X → Y) · gon_Q(Y) along a forgetful map, to a curve Y whose pencil is obvious |
| `cusp_rr` | 5 | Riemann–Roch for an explicit cuspidal divisor D with h⁰(D) = 2 |
| `special` | 2 | Riemann–Roch for a divisor with one non-cuspidal ingredient |

## The arguments

**Pullback** (`pullback.py`). If M | N and Δ mod M ⊆ Δ′, then (E, P) ↦ (E, (N/M)P) is a map
X_Δ(N) → X_Δ′(M) over Q, of degree equal to the ratio of the indices. The targets used are:
- curves of genus 0, 1 or 2, and genus-3 curves;
- curves that are hyperelliptic over Q (MD Sage's `subhyperelliptic_primes`; these are
  X_{±1,±8}(21), X₀(41) and X₀(48); also classical: Ogg for X₀(N), Ishii–Momose for X_Δ(N));
- one cited target, X₁(22), with gonality 4 (Derickx–van Hoeij), used for `44.360.16.e.1`.

Each target has the rational cusp at infinity, which is what makes its pencil obvious.

**Cuspidal Riemann–Roch** (`cusp_certificate.m`, one input file per curve in `certificates/`).
- Weight-2 modular forms f give differentials f dq/q with at most simple poles at the cusps.
- For D = Σ aᵢCᵢ, a sum over the Galois orbits of cusps with aᵢ ≥ −1, h⁰(K − D) is the dimension of
  the forms vanishing to order aᵢ + 1 at each orbit. That is one rank computation.
- Then h⁰(D) = deg D + 1 − g + h⁰(K − D) ≥ 2 gives gon_Q ≤ deg D.

The q-expansions at all cusps come from Zywina's *Modular* package (pinned in `third_party/`; theory
in Zywina, *Classification of modular curves with low gonality*). It is given H_Δ = {(a b; 0 d) : a ∈ Δ}.
It represents each cusp as A·∞ = a/c for a matrix A ∈ SL₂(Z) and expands in q^{1/w}, with w the width.
Each Galois orbit of cusps is named by one representative cusp a/c and its width. Every input file
asserts these names (`expected_cusps`), so D never depends on the package's internal numbering.
The divisors (full output in `certificates/all_certificates.out`):

| Curve | D | deg |
|---|---|---:|
| `41.168.11.b.1` | [2/41] + 5·[3/41] | 6 |
| `41.210.11.b.1` | 8·[7/41] | 8 |
| `41.420.21.d.1` | 11·[2/41] | 11 |
| `49.392.19.i.2` | 5·[9/49] + [6/49] + 4·[12/49] + [2/49] | 11 |
| `45.432.21.g.2` | 2·[8/45] + 2·[2/45] + 2·[13/45] + 2·O(11/15) + O(2/15) + O(1/42) + O(45/44) − O(4/63) − O(8/81) − O(2/9) − O(8/65) − O(1/25) | 10 |

Here [a/c] is a rational cusp and O(a/c) the Galois orbit of the cusp a/c. Each certificate runs in
seconds; run it from `certificates/` with `magma -b <label>.m`.

**Special** (`special/`). These two curves have no cuspidal pencil of the needed degree. The
extended search, with coefficients ≥ −1, is exhaustive and finds none. So one non-cuspidal
ingredient is needed:
- `43.132.9.a.2`, degree 7: D = 3C₃ + 7C₂ − 3C₁ + F_G − F_O, where F_P is the fibre of the degree-6
  map X → X₀⁺(43) (an elliptic curve of rank 1) over P. Runtime 4.5 min.
- `43.308.15.b.1`, degree 9: D = 3·cusp₃ + cusp₄ + P₅, where P₅ is the degree-5 point obtained by
  descending van Hoeij's degree-15 point on X₁(43) (van Hoeij, *Low degree places on the modular curve
  X₁(N)*). Runtime 11.5 min.

  **Status:** both are the old certificates, copied unchanged except for the file paths. They pass,
  but they use the old models (the LMFDB model, and our own modular-unit plane model). The next step
  is to port them to the MD Sage models.

## Files

| File | Role |
|---|---|
| `pullback.py` → `pullback.json` | Best pullback bound for each curve with 41 ≤ N ≤ 50 (Sage with MD Sage; 10 s) |
| `cited_gonalities.json` | Published gonalities available as pullback targets, with sources |
| `orlic_check.py` | Checks that Orlić's Table 1 lists exactly our curves with N ≤ 40 and g ≥ 3, with the same genus and gonality |
| `cusp_certificate.m`, `certificates/` | The five cuspidal Riemann–Roch certificates |
| `special/` | The two special certificates and their inputs |
| `assemble.py` → `upper_bounds.csv` | One row per curve: bound, method and source |
| `discovery/` | The search that found the cuspidal divisors. It is a discovery tool, not a certificate |
