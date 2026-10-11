# Exact-degree-five existence without full model generation

Use the rational Tate cusp P on the mu-model and the Q-isomorphism
proved in RATIONAL_MODELS.md. These arguments therefore apply to the
intended X_Delta over Q, not just over a cyclotomic field.

## Genus three

If a canonical differential is f(q)dq/q and f has order a at q=0,
the differential has order a-1. The pivot exponents of a full echelon
q-expansion basis are thus exactly the Weierstrass gaps at P.
If 5 is not among them, Riemann–Roch gives
dim L(5P) = dim L(4P)+1. A rational function in the difference has
pole divisor exactly 5P and degree five.

The code computes enough coefficients to certify full rank, using the
weight-two bound (in fact a larger weight-four bound). A truncated
dependent basis is never accepted as a gap computation.

## Genus four

For a nonhyperelliptic genus-four curve, the canonical system separates
all geometric effective divisors of degree two, including doubled points.
For any rational point P this implies K-P is basepoint free: at Q the
required strict drop is h0(K-P)-h0(K-P-Q)=1, including Q=P.
It has degree five. Over the infinite field Q a general two-dimensional
subspace of its sections has no common zero and gives a degree-five map
to P1. Hilbert irreducibility yields infinitely many quintic closed points.

Nonhyperellipticity is checked by the multiplication map Sym^2 H0(K)
-> H0(2K). Its image has dimension 2g-1=7 in the hyperelliptic case
and 3g-3=9 otherwise. Products are compared through the weight-four
Sturm/valence bound, so the rank calculation is exact.

These methods prove existence, even if the code does not output a
particular rational expression for the function. Each row contains its
own checked gap sequence or multiplication rank. No previous gonality
database is consulted.
