# Excluding the genus-nine/ten exceptions by elliptic degree

We use the **arithmetic**, not potential-density, row of
[Kadets–Vogt, Proposition 6.3](https://arxiv.org/html/2208.01067v2).
If a curve has minimum density degree five and genus at least nine, it
either admits a degree-five map to P^1 or a positive-rank elliptic curve,
or is the normalization of a Debarre–Fahlaoui curve.

The last alternative also forces a small elliptic map. Definition 5.1
and the proof of Theorem 5.8 place the curve on Sym^2(A), where A is the
positive-rank elliptic curve parametrizing the rational divisor family.
This construction is over the ground field: the spans and incidence maps
in Theorem 5.8 are defined over that field. Its numerical class is

    B = (5+m) H - m F,       1 <= m <= 5.

Using H^2=H.F=1, F^2=0, and K=-2H+F, adjunction gives

    arithmetic_genus(B) = 11 - m(m-1)/2.

The genus of the normalization cannot exceed this. Thus genus at least
nine forces m=1 or m=2. The addition map Sym^2(A) -> A, restricted to the
normalization, has degree B.F=5+m: **six or seven**. Singularities of B
do not invalidate this bound or change the degree to A.

Consequently, a curve of genus at least nine with only finitely many
points of degrees 1–4, no degree-five function, and no maps of degrees
5, 6 or 7 to a positive-rank elliptic curve has finitely many quintic points.
This is a deduction from the cited theorem, not a characterization assumed
from the home-directory code.

## Applications

All three curves below have only finitely many points of degrees 1–4 by
Theorems 1.4–1.6 of [Derickx–Orlić](https://arxiv.org/html/2504.15937v1).
The independent census checks their subgroup index and genus. The published
gonality classification separately rules out degree-five functions.

| Level | Delta | Genus | Elliptic obstruction |
|---|---|---:|---|
| 37 | <-1,10> | 10 | Every positive-rank elliptic map has degree at least 12. |
| 57 | <-1,2> | 9 | Every positive-rank elliptic map has degree at least 8. |
| 73 | <-1,2,3> | 9 | No positive-rank elliptic quotient exists. |

For 37 and 57, fresh factor decompositions check every elliptic factor,
prove its rank by matching bounds, and find exactly one positive-rank
factor, of conductor N and root number -1. The exact modular-symbol
calculation gives optimal modular degree 2 and 4 respectively. Corollary
4.10 of Derickx–Orlić multiplies these by the independently checked covering
degrees 6 and 2. Every map to an isogenous elliptic curve factors through
the optimal parametrization followed by an isogeny, so these are lower
bounds for **all** positive-rank elliptic maps. The script deliberately uses
ModularDegree(ModSym), not the numerical elliptic-curve implementation.

For 73, the fresh J_0 decomposition has simple dimensions 1,2,2, and the
only elliptic factor has rank bounds [0,0]. Elliptic factors of J_Delta
and J_0 agree over Q, as explained in Section 4 of Derickx–Orlić. Thus no
positive-rank elliptic target is possible, irrespective of its degree.

Replay: small_density_elliptic.m with N:=37 and N:=57;
elliptic_factors.m with N:=73. Logs are small_density_37.log,
small_density_57.log and elliptic_factors_73.log.
