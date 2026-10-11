# Gonality and quintic points on intermediate modular curves

Code, data and computational certificates for the paper

> Marin Varivoda, *Gonality and quintic points on intermediate modular curves* (`paper/main.pdf`).

For a subgroup $\lbrace\pm1\rbrace \subseteq\Delta\subseteq(\mathbb Z/N\mathbb Z)^\times$, the intermediate modular curve
$X_\Delta(N)$ lies between $X_1(N)$ and $X_0(N)$. It is *strict* if both inclusions are strict.

## Results

| | Statement |
|---|---|
| **Theorem A** | For the thirty levels $N$ left open by Derickx, Hwang, Jeon and Orlić, $X_0(N)$ has only finitely many points of degree 5 and no morphism of degree 5 to $\mathbb P^1$ over $\mathbb Q$. This completes the list of curves $X_0(N)$ with infinitely many quintic points. |
| **Theorem B** | Exactly 43 strict intermediate curves have infinitely many points of degree 5, and each of them has a morphism of degree 5 to $\mathbb P^1$ over $\mathbb Q$. |
| **Corollary E** | The strict intermediate curves of density degree 5 are exactly the four $\mathbb Q$-pentagonal curves of Orlić. |
| **Theorem C** | The $\mathbb Q$-gonality of all 76 strict curves $X_\Delta(N)$ with $N\le 50$ (`data/strict_intermediate_N_le_50.csv`). |
| **Theorem D** | The $\mathbb Q$-gonality of $X_1(N)$ for $41\le N\le 50$, which equals the Derickx–van Hoeij upper bound at every level. |

| $N$ | 41 | 42 | 43 | 44 | 45 | 46 | 47 | 48 | 49 | 50 |
|---|---|---|---|---|---|---|---|---|---|---|
| $\mathrm{gon}_{\mathbb Q} X_1(N)$ | 22 | 12 | 24 | 15 | 18 | 19 | 29 | 16 | 21 | 15 |

## How the proofs work

Every case is settled either by a published result, by the Castelnuovo–Severi inequality, or by one of three
computational methods.

1. **Explicit pencils** (upper bounds). A rational effective divisor $D$ with $\ell(D)\ge 2$ gives
   $\mathrm{gon}_{\mathbb Q}\le\deg D$: divisors supported on cusps (computed from $q$-expansions at all cusps),
   pullbacks of pencils along forgetful maps, and Riemann–Roch in low genus.
2. **Finite-field exclusion** (lower bounds). At a prime $p$ of good reduction,
   $\mathrm{gon}_{\mathbb Q} X\ge\mathrm{gon}_{\mathbb F_p} X_{\mathbb F_p}$, and the latter is computed by the
   algorithm of Derickx and Terao. Their package CurveArith has two phases: (1) the places of small degree and the
   expansions of holomorphic differentials there, and (2) a search for effective divisors $D$ with
   $\ell(D)\ge2$, using $\ell(D)=\deg D+1-\mathrm{rank}\,M_D$. For the large curves $X_1(N)$ we use phase 1
   unchanged and replace phase 2 by a search over a smaller family of divisors $bS+E+Q$ (paper, §3.3), reading
   the least degree of a function in $L(H)$ off the kernel of $M_H$. For $X_1(48)$ the search runs on the
   quotient by the diamond involution $\langle 23\rangle$ instead (paper, §5.1).
3. **Lifting** (when a finite field has more pencils or divisor classes than $\mathbb Q$). Rank-zero
   Jacobians, an explicit description of $J(\mathbb Q)$ as a positive-rank part plus a finite group, and a local
   rigidity lemma decide which classes over $\mathbb F_p$ come from $\mathbb Q$.

## Layout

| Path | Contents |
|---|---|
| `paper/` | LaTeX source (`main.tex`, `sections/`, `tables/`, `refs.bib`) and `main.pdf` |
| `data/` | One row per curve, with both bounds and the method and certificate or citation for each (see `data/README.md`) |
| `certificates/A_x0_quintic/` | Theorem A: 36 Magma certificates and their logs, with a runner |
| `certificates/B_intermediate_quintic/` | Theorem B and Corollary E: the census of all 1388 pairs $(N,\Delta)$ with $N\le191$ and every certificate |
| `certificates/B_class_E_degrees/` | Theorem B: modular degrees of the positive-rank elliptic curves used in class E |
| `certificates/C_intermediate_gonality/` | Theorem C: canonical models, good-reduction checks, CurveArith lower bounds, upper-bound certificates |
| `certificates/C_43.132.9.a.2/` | Theorem C: the curve 43.132.9.a.2, of gonality 7 (paper, Proposition 4.1) |
| `certificates/D_x1_gonality/` | Theorem D: the two-phase computation for $X_1(N)$ and the double cover for $N=48$ |
| `third_party/` | Pinned external packages (git submodules) |
| `verify.py` | Checks that every claim in `data/` is backed by a passing log or a citation |

## Reproducing

Requirements: Magma V2.29-4, SageMath 10.7, Python 3, and for Theorem D a C++20 compiler with GMP.

```sh
git clone --recursive https://github.com/marin-varivoda/intermediate-modular-curves
cd intermediate-modular-curves
python3 verify.py                                    # checks all saved logs (seconds)
```

Each folder in `certificates/` has a README explaining what it proves and how to rerun it. The longest
computations are those of Theorem D (up to 30 hours of wall-clock time per level, with up to
150 GB of memory per process for $X_1(47)$); everything else runs in minutes to an hour.

## External software and data

| Package | Authors | Used for | Version |
|---|---|---|---|
| [MD Sage](https://github.com/koffie/mdsage) | Maarten Derickx | enumeration of the groups $\Delta$, canonical models | `6022429` |
| [CurveArith](https://github.com/nt-lib/CurveArith) | Maarten Derickx, Kenji Terao | gonality over finite fields (phase 1 of every $X_1(N)$ computation) | `b7c6192` |
| [Modular](https://github.com/davidzywina/Modular) | David Zywina | $q$-expansions at all cusps | `ce31d78` |

The models of $X_1(N)$ are the optimized models of Sutherland and van Hoeij. Curves are named by their
[LMFDB](https://www.lmfdb.org) labels; every label was checked against the group $\Delta$ by conjugacy in
$\mathrm{GL}_2(\mathbb Z/N\mathbb Z)$. The bibliography of the paper lists every published result used.

## Citation

See `CITATION.cff`.
