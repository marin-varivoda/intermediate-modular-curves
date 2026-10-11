# Level 40: complete rational divisor-class certificate

This concerns Delta = {1,3,9,13,27,31,37,39}, genus 7. The verifier is
`run_case40_certificate.py`, run with Sage's Python. The statements below
are a certificate criterion: the classification changes only after the
entire verifier finishes and writes its hash manifest.

## Integral lattice

Use the full GammaH modular-symbol space, not character-by-character lattices.
The images of all integral Manin symbols generate relative integral homology
of the compact modular curve relative to its cusps. Intersecting this lattice
with the rational kernel of the cusp boundary gives absolute integral homology:
the integral boundary target is free, so its rational and integral kernels
agree on the integral lattice. There are no elliptic stabilizers in this case.
`audit_integral_homology40.py` checks this construction against Sage's lattice
using every Manin generator and the boundary matrix independently.

## Torsion constraints

On H_1(Q)/H_1(Z), complex conjugation acts by the star matrix. Rational torsion
is in its fixed subgroup. At good primes p, Eichler--Shimura gives the additional
prime-to-p constraint 1-T_p+p< p >. The Hecke recurrence identifies this with
1-T_p+T_p^2-T_(p^2), avoiding diamond-normalization assumptions. This is the
Hecke-bound method of [Derickx et al., section 4.3](https://arxiv.org/html/2007.13929v2#S4.SS3).

Matrices act on row coordinates in Sage. Therefore stacking their transposes
and taking Smith normal form computes the invariant factors of the simultaneous
kernel on (Q/Z)^(2g), by finite-group duality. The new probe explicitly omits
the residue prime when bounding its primary torsion, rather than imposing an
unjustified same-characteristic reduction condition.

For primes 3,7,11,13, every omission run gives nontrivial invariants
[2,24,168], of order 8,064. The independent Frobenius-order bound is 28,224.
Consequently their greatest common divisor bounds rational torsion by 4,032.
The six known rational point differences generate a reduction subgroup of
order 4,032. Rank zero makes these actual torsion points. Once all input
certificates and the homology audit are verified, the lower and upper bounds
coincide: this subgroup exhausts J(Q).

## Exhausting degree-five pencils

The exhaustive mod-3 special-divisor sieve leaves twelve classes in this
subgroup. For each, lift using the supplied signed rational point divisor
and compute its full rational Riemann--Roch dimension. If h0 is at most one,
there is no pencil. Otherwise the verifier requires h0 exactly two and
exhibits a rational base point. These computations use an exactly isomorphic, LLL-simplified
canonical model, with substitution and inverse substitution checked.
Before the rational checks, the verifier shortens the signed representatives
and checks equality of their reduction classes. Since their differences
are rational degree-zero divisors and J(Q) is torsion with injective
reduction, equality of reduction classes proves rational linear equivalence.
The bounded shortening search is merely an optimization: it does not
discard any of the twelve classes, and each final representative is checked.
All shortened representatives here are effective and cusp-supported.

The dimension computation avoids function fields altogether. For a rational
point P and multiplicity m, the saturated ideal I(C)+I(P)^m defines the
length-m fat point on the smooth curve; the verifier checks that length.
Its linear equations are exactly the canonical hyperplanes vanishing at
least m times at P. Intersect these vector spaces over the support of D
to obtain H0(K-D), and use Riemann--Roch to compute h0(D). For a support
point P, equality h0(D-P)=h0(D)=2 proves that P is a base point. The six
classes with h0=2 are precisely D4+P for the six supplied points, with
D4=P1+2P3+P6 in the reported short coordinates. No global factorization
or assumption about completeness of a bounded point search is required.

Why is the finite-field sieve exhaustive? A rational degree-five pencil
has a class in Pic^5(Q), hence a unique translate by 5P_0 of a class in
the now completely known J(Q). Its reduction has h0 at least two by
semicontinuity. Enumeration of all effective degree-five divisors over
F_3 therefore includes it. Injectivity of reduction on rational torsion
identifies its rational class with the signed lift tested by the verifier.
There are twelve such reduction classes, and all twelve must pass.

Finally, rank zero makes Pic^5(Q) finite. A class with h0 at most one
contains at most one effective divisor. If it contains an irreducible
degree-five divisor and h0 is at least two, its linear system cannot have
a nonzero fixed divisor: such a fixed divisor would be a proper rational
subdivisor of that irreducible divisor (or the whole divisor, forcing h0=1).
The verified base-point exclusions therefore show that only finitely many
irreducible degree-five divisors exist. Equivalently, this curve has only
finitely many closed points of degree five and no rational function of
degree exactly five.

No conclusion is drawn from an unfinished process or a bounded point search.
The replay regenerates the reduction sieve, the signed lifts and coordinate
change, all twelve rational checks, the rank-zero test, and both torsion
bounds. Its manifest includes all relevant source and artifact hashes.
