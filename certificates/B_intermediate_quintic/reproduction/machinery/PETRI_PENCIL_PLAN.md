# Pending pencil-lifting criterion

**Historical note:** the complete replays have now passed at 36,39,75.
Their accepted proof is PETRI_LIFTING_CERTIFICATE.md, with hashed
petri_certificate.json files in the respective integral_model directories.

This is not yet an accepted finiteness certificate. The exhaustive local
tests below are complete, but characteristic-zero quartic pencils still
need to be exhibited with the requisite reductions.

Let C have good reduction at p. Write W^1_5 for degree-five line bundles
with at least two sections. At a class D with h0(D)=2 its tangent-space
annihilator is the image of the Petri multiplication

    H0(D) tensor H0(K-D) -> H0(K).

The new `petri_pencil_census.m` enumerates all effective degree-five classes
over F_p, identifies every one with h0>=2, and computes this image exactly
in one Riemann--Roch basis. For a pencil, its moving degree is the degree
of the ratio of the two basis sections. No inference is made from a
negative bounded search over Q.

The promising outputs are:

| Level | Genus | Prime | #C(F_p) | W^1_5 classes | Moving degree | Tangent dimension |
| --- | --- | --- | --- | --- | --- | --- |
| 36 | 7 | 5 | 9 | 27 | 4 throughout | 1 throughout |
| 39 | 9 | 2 | 6 | 12 | 4 throughout | 1 throughout |
| 75 | 9 | 2 | 4 | 8 | 4 throughout | 1 throughout |

Suppose explicit basepoint-free quartic line bundles A_i over Q (or over
Q_p with good integral extensions) have reductions such that the classes
A_i+P, P in C(F_p), cover the entire census. Their translated Abel curves
are contained in the relative W^1_5. The Abel map is an immersion. The
dimension-one tangent test then identifies each completed local W^1_5
with that known smooth branch, by eliminating transverse variables as in
ELLIPTIC_FAMILY_CERTIFICATE.md. Its generic line bundles still have h0=2
by upper semicontinuity, and their extra point is a base point. Therefore
there is no basepoint-free degree-five pencil over Q. Rank zero, when
independently certified, then proves finiteness of irreducible quintics.

The crucial missing step is the explicit lift of the quartic classes;
their existence over F_p alone does not suffice. The new
`rational_quartic_pencils.m` searches for and records certified quartic
divisors on rational points of the new Q-models.

At level 36 this search has now found three distinct Q quartic pencils,
recorded in its integral_model/quartic_witnesses.m. The combined verifier
`verify_petri_lifting.m` is checking their reductions against the entire
census. The level-39 and level-75 Q searches are still running.

The other cases have genuinely less decisive local outputs: level 40
has some tangent dimensions two; both level-48 curves have moving-degree
five pencils in the tested reduction; level 64 has 32 such classes and
all its special degree-five classes have tangent dimension three.
