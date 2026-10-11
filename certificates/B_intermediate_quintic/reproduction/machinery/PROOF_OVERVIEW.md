# Proof structure

The generated `CLASSIFICATION_TABLE.md` is the authoritative statement of
which cases have completed certificates. This overview explains the small
number of ideas behind the classification; it does not promote an unfinished
calculation to a theorem.

We classify pairs (N,Delta), with {±1} contained in Delta contained in the
unit group modulo N. Thus two rows may give isomorphic curves. The intended
points are closed points of residue degree **exactly five** over Q.

## First make the problem finite

If C -> D is a finite rational map, a quintic point maps to a point of
degree one or five. Consequently, when D has only finitely many rational
and quintic points, C has only finitely many quintic points. The rational
point hypothesis matters: it is supplied by genus(D)>1 and Faltings.

Apply this to C=X_Delta(N) and D=X0(N), using the completed X0 classification.
It excludes all N>=192 and most curves below that boundary. Repeat with
other already excluded intermediate targets whenever the subgroup inclusion
defines a forgetting map. A geometric gonality bound greater than ten gives
another uniform exclusion, by Frey's necessary bound for quintic density.

Enumeration of the remaining pairs is exact: primitive bottom rows modulo N,
modulo the free Delta action, give the cosets of the congruence subgroup.
Their standard permutations determine the index, cusps and genus. A second
enumeration using Sage's abstract unit groups and GammaH independently checks
all 1,388 pairs through 191, including 1,011 strict intermediate pairs.
See `AUDIT.md` and the independent census replay.

## Positive answers: functions of exactly degree five

A rational map C -> P1 of degree five yields infinitely many quintic closed
points by Hilbert irreducibility. We therefore seek such maps directly.
There are 43 proved positive strict intermediate pairs in the table:
13 by elementary low-genus arguments, 14 by exact genus-three/four checks,
4 by published pentagonality results, and 12 by new explicit witnesses.

For each new witness, the curve is first identified over Q from the full
space of canonical differentials and exact q-expansion relations. A
Riemann--Roch calculation then supplies a function whose pole divisor has
degree exactly five. A degree-four function is not substituted for this
check. Some witnesses need a quadratic closed point, illustrating why a
search supported only on rational points would be insufficient.

## Rank zero: reduce to finitely many divisor classes

With a rational cusp as base point, degree-five rational divisor classes
form a torsor under J(Q). If the Jacobian has rank zero, this is a finite
set. A single irreducible quintic divisor D with h0(D)>1 would give a
degree-five function: a nonconstant rational section can have poles only
at D, hence has pole degree five. Thus excluding such functions suffices
for quintic finiteness in rank zero.

Usually a published gonality bound already excludes the function. The
exceptional cases require more: either a complete rational divisor-class
sieve, or a finite-field lifting argument proving that every possible
pencil retains a base point. In the class sieves, the rational torsion
group is proved, not guessed from reductions. At level 48 its bound uses
an explicitly checked integral pullback into the cuspidal torsion of J1(48).
Exact canonical hyperplane conditions make the final Riemann--Roch checks
short. See `HECKE_TORSION40.md`, `PULLBACK_TORSION48.md`, and
`PETRI_LIFTING_CERTIFICATE.md`.

## Positive rank: exclude the families, not just the functions

Here nonexistence of a degree-five function is not enough. Two tools cover
the remaining possibilities.

In sufficiently large genus, the published density theorems reduce quintic
density to a small-degree map to P1 or a positive-rank elliptic curve.
The minimum-density hypotheses are checked using the lower-degree
classifications. Optimal elliptic parametrizations then exclude the
necessary degrees. The genus-nine/ten Debarre--Fahlaoui alternative forces
a degree-six or degree-seven elliptic map, also excluded in its applications.
See `ELLIPTIC_DEGREE_EXCLUSIONS.md` and `DEBARRE_FAHLAOUI_OBSTRUCTION.md`.

For the small exceptional positive-rank curves, work instead inside W5,
the locus of effective degree-five line bundles in the Jacobian. The only
positive-rank factor is a single elliptic factor. Mordell--Lang reduces
infinite rational divisor families to elliptic translates inside W5.
Enumerate all degree-five classes over a good finite field and test all
cosets of the elliptic subgroup. At level 43 no such coset survives.

At levels 53,61,65, degree-four elliptic maps give an expected surface of
classes represented by a fiber plus one point. The finite-field tests show
that every full coset lies on that known surface. Tangent bounds and
immersion then prove, by formal lifting, that there is no other elliptic
family in characteristic zero. A uniquely represented fiber-plus-point
class cannot be an irreducible quintic divisor. Conversely, if an irreducible
quintic divisor had h0>1, it would give the already excluded degree-five
function. Thus all
quintic points outside the known reducible families are finite in number.
See `ELLIPTIC_FAMILY_CERTIFICATE.md` and its level-65 and small-prime supplements.

## What the computation certifies

Model identity, rational descent, good reduction, complete class enumeration,
rank information, and lifting hypotheses are separate verification gates.
Every accepted special-case replay has a manifest linking its subgroup,
source files and mathematical outputs. Searches can find positive witnesses,
but a finite unsuccessful search never supplies a negative result.
`audit_results.py` checks the saved ledger; `REPRODUCING.md` explains how to
recompute the underlying mathematics. Published inputs remain explicitly
named in the individual proof notes.
