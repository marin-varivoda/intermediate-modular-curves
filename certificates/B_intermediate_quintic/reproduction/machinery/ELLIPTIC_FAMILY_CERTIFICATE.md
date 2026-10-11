# Finiteness by identifying the reducible elliptic surface

This certificate concerns the genus-eight curves at levels 53 and 61, and
is also designed to test the remaining three curves at level 65. A curve
is accepted only when `run_family_certificate.py` completes successfully.
The existence of the explicit certificate file, not this list of intended
applications, determines the classification ledger.

## The criterion

Let C/Q have no function of degree five, and suppose the connected
Mordell--Weil closure in J(C) is contained in a single elliptic subvariety A.
Suppose f:C -> E has degree four and image f*J(E)=A. Let

    Z = { f*Q + P : Q in Pic^1(E), P in C }  inside Pic^5(C).

This is a proper closed image. Its divisors are fibers plus points.
Choose a good prime p not dividing 4*#E(F_p), and write B=A(F_p).
The following three finite-field checks imply that C has only finitely
many irreducible degree-five points over Q:

1. Every full B-coset contained in W5(F_p) consists of known classes
   F4 + P + B, where F4 is an explicitly exhibited fiber class and P is
   an F_p-rational point of C.
2. At every such coset, the intersection of the tangent spaces to the
   translates of W5 has dimension at most two.
3. The differential of A x C -> Pic^5(C) has rank two at each relevant
   rational reduction point.

## Why the criterion works

All objects are considered over Z_p using their good models. The morphism
f extends to these models: the forgetting map has positive-genus target,
and the subsequent quotient is by an involution of order prime to p.
The identity f_* f*=[4] shows that f* has prime-to-p kernel, and its image
A is a smooth elliptic subgroup in the good Jacobian model. Thus reduction
does not collapse its tangent line.

Every element of B lifts uniquely to prime-to-p torsion of A over Z_p.
Intersect the corresponding translates of the relative Brill--Noether
locus W5, and call the intersection T. Any A-translate contained in W5
is contained in T. The whole known surface Z is contained in T as well.

Let y be the reduction of a rational point on such an A-translate. Check 1
places y on a parametrized branch of Z with a rational reduction preimage
in A x C. Both factors are smooth over Z_p, so that preimage lifts and
its completed local ring is Z_p[[u,v]]. Check 3 says its map into the
smooth Picard scheme is a formal immersion. Check 2 bounds the relative
tangent dimension of T at y by two. Therefore T is exactly this smooth
formal branch near y. Explicitly, choose g-2 equations with independent
transverse derivatives and eliminate the transverse variables by the
formal implicit function theorem. Any remaining equation vanishes on
the contained formal surface, so is zero. This also excludes p-torsion
or additional infinitesimal components; it is not just a dimension count
on the special fiber. Consequently the A-translate has a nonempty formal
open subset in Z and, since Z is closed, is contained in Z.

Mordell--Lang now applies. Infinitely many rational points of W5 would
have an elliptic translate in their Zariski closure, since all other
simple factors have rank zero and the elliptic factor has multiplicity
one. Every such translate is contained in Z by the preceding argument.
There are only finitely many isolated components of that closure.

An irreducible effective quintic divisor D cannot belong to Z. Indeed,
if h0(D)=1, its unique effective representative over Qbar would be f*Q+P.
The leftover point P is unique: two unequal fibers have disjoint support,
whereas D-P and D-P' share degree at least three. Hence P is rational by
Galois invariance, contradicting irreducibility of D. If h0(D)>1, a
nonconstant rational element of L(D) has pole divisor exactly D, because
D is a single closed point, and gives the excluded degree-five function.
Thus each remaining isolated divisor class contributes at most one
irreducible quintic divisor. This proves finiteness.

## What is computed, and why it is sufficient

The canonical models are identified scheme-theoretically by the independent
q-expansion/Hilbert-polynomial certificates. Canonical forgetting maps are
checked as identities of q-expansions beyond the source Sturm bound.
The Fricke involution on the new X0 model is computed independently in
Magma and its genus-one quotient has a rational cusp. Its elliptic curve
has conductor N and proven rank one. Full factorization of J_Delta has
one potentially positive elliptic factor with multiplicity one; all other
factors have nonzero central L-value and hence rank zero. These are
isogeny-invariant uses of JH; no integral homology lattice is assumed.

Integral relation lattices are saturated without changing coordinates.
The special fibers are checked reduced and irreducible, with normalization
genus equal to arithmetic genus and a rational point. Together with the
same generic and special Hilbert polynomials, this supplies smooth proper
good models. The reduced forgetting map has degree two, and Fricke is an
involution with a one-dimensional invariant differential space.

Differences of pulled-back elliptic fibers generate a subgroup of order
#E(F_p). It lies in A(F_p), whose order is the same by isogeny invariance;
therefore this subgroup is all of B. Every effective degree-five class is
enumerated using all closed places of degrees 1 through 5 and all
partitions of 5. Over a finite field rational effective line bundles have
rational effective representatives, so none are omitted.

At a divisor D with h0(D)=1, the tangent annihilator to W_d is H0(K-D).
Rows from these spaces are combined over each B-orbit. Divisors with
h0(D)>1 are ignored, which only weakens the upper bound. The known surface
provides the matching lower bound after the immersion test.

For that last test, intersect the tangent spaces of W4 at explicitly
pulled-back fibers with h0=1. They all contain the tangent line of A.
Their computed intersection has dimension one, so identifies that line
exactly. At each rational point P, compare it with the Abel-map tangent,
whose annihilator is H0(K-P). Distinct lines prove rank two. This uses
one consistent Riemann--Roch differential basis, avoiding coordinate or
normalization ambiguities in a trace-of-differentials computation.

## Completed local tests

| Level | Genus | Prime | #B | #W5(F_p) | Known classes | B-orbits |
| --- | --- | --- | --- | --- | --- | --- |
| 53 | 8 | 5 | 6 | 7294 | 48 | 8 |
| 61 | 8 | 5 | 9 | 16606 | 90 | 10 |

Every listed orbit has tangent intersection dimension two; immersion
passes at all eight respectively ten rational points of the source.
The full replay additionally checks the model, forgetting map, elliptic
quotient, factor profile, and source/artifact hashes before acceptance.
