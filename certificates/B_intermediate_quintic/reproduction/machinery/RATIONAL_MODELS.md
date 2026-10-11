# Rational structure of the canonical construction

This note specifies which Q-model the rational q-expansions construct.
It is part of the mathematical certificate, not an experimental test.

## 1. Two moduli conventions

Let X_point(N) classify elliptic curves with an injection Z/NZ -> E,
and let X_mu(N) classify elliptic curves with an injection mu_N -> E.
Use compactified coarse curves and work in characteristic zero.
Their complex analytic curves are both associated to Gamma_1(N), but
the analytic identity does not identify their rational structures.

On X_mu the Tate curve has its canonical inclusion mu_N -> Tate(q).
This is defined over Q((q)), and gives a Q-rational cusp and parameter.
Under the usual complex trivialization of mu_N, this is the standard
analytic q-expansion at infinity. Thus the rational q-expansion structure
used by Sage's CuspForms(GammaH, 2, base_ring=QQ) is the mu convention.

Primary reference: Conrad, Edixhoven and Stein, *J_1(p) Has Connected
Fibers*, discussion of X_mu(N) and its rational cusp/q-expansions:
https://virtualmath1.stanford.edu/~conrad/papers/j1p.pdf
For the distinction from point-marked expansions see Conrad's
*Algebraic theory of q-expansions*, Example 2.3:
https://math.stanford.edu/~conrad/248BPage/handouts/qexp.pdf

## 2. A Q-isomorphism, not the analytic identity

Given i: mu_N -> E, form the quotient isogeny phi: E -> E'=E/i(mu_N).
Cartier duality identifies the kernel of the dual isogeny phi^vee with
(mu_N)^D = Z/NZ, with a distinguished injection determined by i.
This defines a point-marked pair on E'. Conversely, quotienting a
point-marked pair by its Z/NZ subgroup and dualizing gives a mu-marked
pair. Double duality shows these constructions are inverse, up to the
canonical isomorphisms of elliptic curves. They are defined over Q.
They extend to the smooth projective compactifications by the extension
property for isomorphisms of function fields of curves.

Replacing a marking by its a-multiple changes the dual marking by its
inverse a^-1 (a harmless common sign depends on conventions). Every
subgroup Delta is closed under inversion and contains -1. The isomorphism
therefore descends to

    X_mu(N)/Delta  ~=_Q  X_point(N)/Delta = X_Delta(N).

It changes the modular interpretation of a point and generally the
underlying elliptic curve, but preserves closed-point degrees, rational
function degrees, rational gonality, and the Jacobian up to Q-isomorphism.
Those are precisely the invariants needed here. Subgroup quotient maps
are compatible with these isomorphisms. Other named maps, including
degeneracy and Atkin–Lehner maps, must still be transported explicitly.

## 3. Rational canonical forms

The full weight-two cusp space is H^0(X_mu(N), Omega^1) after taking
the usual modular-form/differential identification. The q-expansion
principle at the rational Tate cusp identifies its Q-structure with
rational coefficient expansions. Taking Delta invariants commutes with
base change in characteristic zero and gives the differential space of
X_mu(N)/Delta. Analytically it is S_2(Gamma_Delta).

Thus a full rational q-expansion basis used by canonical_relations.py is
a rational canonical basis of a curve Q-isomorphic to the intended
X_Delta. Its polynomial relations over Q give the corresponding rational
canonical image. This does not assert that any arbitrary finite list of
relations cuts out the image: that is the separate geometric check.

## 4. The genus-five complete-intersection certificate

For the current genus-five examples, the quadratic multiplication rank
is 12. A hyperelliptic genus-five canonical system has quadratic image
rank 9, so these curves are nonhyperelliptic. Their full canonical map
is a closed immersion with image degree 8.

Three exact independent quadratic relations cut out a projective scheme
which Magma checks is one-dimensional, smooth, and degree 8. In P^4
these three quadrics form a complete intersection. Over an algebraic
closure such a positive-dimensional projective complete intersection is
connected; smoothness then implies geometric integrality. It contains
the canonical image of degree 8, so it equals that image as a scheme.

Combining Sections 1–3 with this check proves these are Q-models of the
intended curves, not merely matching-genus curves or unverified twists.
The leading q-coefficient vector gives the rational Tate cusp on each
canonical model. Check its coordinates in the equations before use.

## Boundaries of this certificate

- A rational canonical model is not yet a degree-five function or a
  classification of rational divisor classes.
- The smooth Q-model need not have good reduction in its displayed
  integral coordinates at every p not dividing N. Check reductions.
- Non-canonical low-genus models and canonical ideals outside this
  complete-intersection case need their own geometric certificates.
- A geometric cusp width is not a residue degree of its field of definition.

## Low-genus consequence

Every curve under consideration has a rational point: the Tate cusp on
the mu-model, transported by the Q-isomorphism. If genus g <= 2, the
rational line bundle O(5P) has degree at least 2g+1 and is very ample.
Over the infinite field Q a general pair of its sections has no common
zero (equivalently choose a projection center disjoint from the embedded
curve). Their ratio has degree exactly five. Hilbert irreducibility then
gives infinitely many closed points of exact degree five. This argument
does not require a positive-rank genus-one Jacobian.
