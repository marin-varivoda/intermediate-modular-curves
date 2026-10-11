# Exact linear pullbacks for the three level-65 family certificates

The finiteness criterion and formal lifting proof are in
`ELLIPTIC_FAMILY_CERTIFICATE.md`. This note explains the replacement for
generic function-field pullback; it does not weaken any proof obligation.
The three source curves have genera 9,11,11 and degree two to X0(65),
of genus five. The Fricke quotient of X0(65) is an elliptic curve of
positive rank. Their composite has degree four.

At prime 7 the elliptic quotient has twelve rational points. Some fibers
on X0(65) are nonsplit quadratic places, so using only rational points
of X0(65) would miss most of the elliptic subgroup. The helper
`quotient_rational_fibers.m` includes every rational pair Q+w(Q), every
ramified rational double point, and every quadratic place whose Frobenius
conjugate equals its Fricke image. These exhaust rational quotient fibers.
All twelve fibers at this prime are reduced; the verifier checks this.

Write L for the linear system giving the canonical forgetting map C->Y.
Its common fixed divisor R has degree 2g(C)-2-2(2g(Y)-2), namely zero or
four. Removing R identifies its moving line bundle with the pullback of
K_Y. Since the image is the nonconstant canonical curve Y, this degree
identity also certifies that the forgetting map has degree two.

For a reduced degree-two quotient fiber D on Y, compute the linear span
of its two geometric points, over the ground field. Check that its
intersection with Y has length two. It then cuts out exactly D. Pull
these linear forms back using L. Their common divisor on C is R+phi*D;
subtract R to obtain a degree-four elliptic fiber, including at ramification
points. This procedure treats split and nonsplit fibers uniformly.

## Local conversion of a linear section to a divisor

`linear_scheme_divisor.m` computes the divisor of a zero-dimensional
linear section Z without invoking a generic ideal-divisor conversion.
At a candidate closed place P, choose a projective coordinate nonzero
at P. Divide each defining linear form by that coordinate. On the smooth
local curve, the multiplicity of Z at P is the minimum of their valuations.
Sum those multiplicities and check that the resulting divisor's degree is
exactly the scheme length of Z. Thus no omitted place or multiplicity can
escape the check. Zero forms are ignored in the minimum.

For these fibers, places of degrees at most four suffice: both R and phi*D
are rational effective divisors of degree at most four. The degree check
would fail if this support bound or a coordinate computation were wrong.
Projective representatives are cached only for speed.

The full certificate must still verify good reduction, the subgroup order
twelve, every complete elliptic-subgroup coset in W5(F7), all tangent
intersection bounds, and immersion at all relevant rational points.
It must also replay the rational model/map identities, absence of a
degree-five function, and the Jacobian factor/rank profile. No finite-field
fiber count by itself is accepted as a finiteness proof.
