# Recognizing reducible elliptic families (work in progress)

**Historical working note:** the tests and audited proof for levels 53
and 61 are now complete. See ELLIPTIC_FAMILY_CERTIFICATE.md and their
family_jobs certificate.json files. The discussion below preserves the
exploratory route; its statements of pending status are historical.

This document records the proposed next certificate, not an accepted
classification. In particular, finite-field coset counts alone do not prove
finiteness over Q. The tangent and lifting hypotheses below must also hold.

## Situation

Let C/Q have no degree-five function. Suppose the only simple factor of J(C)
that can have positive Mordell--Weil rank is one elliptic factor, with
multiplicity one. Construct a degree-four map f:C -> E to that factor.
Write A for the elliptic subvariety f*J(E) of J(C). Mordell--Lang implies that
infinitely many rational points of W5 would force an A-translate in W5.

There is already a surface Z = f*Pic^1(E) + C inside W5. Its divisors are a
degree-four fiber plus a point. These do not give irreducible quintic points.
Our task is to exclude any additional A-translates, not to exclude Z.

## Finite-field tests

Choose good reduction at p, with #E(F_p) prime to p. Verify the models and the
degree of f. Generate B from differences of explicitly pulled-back fibers;
check its order is #E(F_p). Since these classes lie in the reduction of A,
and isogenous elliptic curves have equal point counts, B equals A(F_p).

Enumerate every effective degree-five divisor class using all closed places
of degrees 1 through 5 and all partitions of 5. Check that the union of
complete B-cosets in W5(F_p) is exactly the set of known classes F4+P+B,
with P in C(F_p). All choices of degree-five base class are harmless shifts.

At each complete B-coset, intersect the tangent spaces of the translated W5.
For a representative D with h0(D)=1 the annihilator of its tangent space is
H0(K-D). Representatives with h0(D)>1 impose no conditions in this test.
Require the computed intersection to have dimension two. This is an upper
bound for the actual intersection tangent space; the known surface supplies
the matching lower bound once its immersion is checked.

Independently check that A x C -> Pic5 has differential of rank two at every
relevant reduction point. The Abel-map tangent line is the canonical point.
The elliptic tangent direction is dual to trace of differentials along f.
For our two successive quadratic maps, trace of a rational function h in
the first extension is Norm(h+1)-Norm(h)-1, followed by s+w*(s) for the
elliptic quotient. These exact computations also check that each resulting
coefficient is constant. Their contraction against a pulled-back invariant
differential must be 4, which is nonzero at the selected primes.

## Lifting argument to audit before accepting a certificate

The prime-to-p points of B lift uniquely to torsion sections of A over Z_p.
Intersect W5 translated by those sections; call this scheme T. Every
A-translate in W5 is contained in T, and the known surface Z is contained
in T as well. The finite-field test places every candidate rational
reduction point on the image of A x C.

At each such point, the immersion gives a smooth formal surface branch
contained in T. The tangent bound two should identify T locally with this
branch: eliminate the transverse coordinates by the formal implicit
function theorem, and use containment of the smooth branch to show that
the remaining equations vanish. This step requires the good integral
models of the maps and Picard varieties, not just a calculation on isolated
special fibers. A candidate A-translate then has a nonempty formal open
subset in Z and is therefore contained in Z.

Finally, if an effective divisor D of degree five defined over Q has h0=1
and lies in Z geometrically, its unique effective representative has the
form f*Q+P. The leftover point P is unique: two different fibers have
disjoint support, whereas D-P and D-P' would share a divisor of degree at
least three. Hence P is Galois invariant and rational, so D is reducible.
If h0(D)>1 and D were irreducible, a nonconstant function in L(D) would
instead have pole divisor D and degree exactly five, already excluded.

## Present computations

* Level 53, genus 8, p=5: W5 has 7,294 classes. Complete elliptic cosets
  consist of exactly 48 known classes; #B=6 and #C(F5)=8.
* Level 61, genus 8, p=5: W5 has 16,606 classes. Complete elliptic cosets
  consist of exactly 90 known classes; #B=9 and #C(F5)=10.

The tangent tests passed: all eight orbits at level 53 and all ten orbits
at level 61 have intersection tangent dimension exactly two. The independent
immersion tests are still running. Neither curve has been removed from the
unresolved ledger on the basis of these tests alone.
