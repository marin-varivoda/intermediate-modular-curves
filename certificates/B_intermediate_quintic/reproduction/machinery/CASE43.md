# Level 43: exclusion of all elliptic translates

Let C=X_Delta(43), with Delta=<-1,2>. The independent enumeration gives
genus 9 and covering degree 3 to X_0(43). The published gonality
classification gives gonality at least six, hence no degree-five function.

The fresh factorization in `case43_factors.m` proves that the only
potentially positive-rank simple factor of J(C) is one copy of the
elliptic isogeny class

    E: y^2+y=x^3+x^2.

Every other simple factor has nonzero central L-value and therefore rank
zero. The script additionally proves rank(E)=1 and #E(F_2)=5.

## Good reduction and the exhaustive test

The original rational equations had denominators divisible by 2.
`integral_relations.py` replaces the basis of each relation space by a
saturated integral lattice basis. It checks equality of the rational
relation spaces: the characteristic-zero curve and its coordinates do not
change. This is stronger than clearing denominators independently.

The resulting special fiber is irreducible and reduced, with arithmetic
genus 9, normalization genus 9, and a rational place. Therefore it is
smooth and geometrically integral. Its Hilbert polynomial agrees with
the generic canonical curve's polynomial, giving a flat projective model
over Z_(2); thus this is good reduction of C, not just an unrelated curve.

The complete place and class-group computation over F_2 gives

    numbers of degree 1,...,5 places: 9,4,2,0,0;
    J(F_2) = Z/38 x Z/1330;
    #W_5(F_2) = 2133.

Here W_5 is shifted into J by subtracting five times a rational place.
We enumerate every partition of five and every corresponding multiset of
closed points. This enumerates all effective rational degree-five divisors,
including those with non-rational support. Their classes are all of W_5(F_2):
over a finite field the Brauer obstruction is zero, and an effective
geometric line-bundle class defined over F_2 has a nonzero F_2 section.

There is exactly one order-five subgroup H of J(F_2). The exhaustive test
finds **no coset c+H wholly contained in W_5(F_2)**.

## Why this proves finiteness over Q

Up to isogeny, all non-elliptic factors of J have finite rational groups.
Consequently the Zariski closure of J(Q) is a finite union of translates
of its unique elliptic subvariety A isogenous to E. If W_5(Q) were infinite,
its intersection with one of those translates would be infinite, hence
Zariski dense in that elliptic curve. It follows that c+A is contained in
W_5, with c rational (chosen from this infinite intersection).

Specialize this inclusion at 2. A has good reduction, isogenous to E's,
so #A(F_2)=5. Its order-five subgroup injects into J(F_2): specialization
preserves prime-to-2 torsion and the inclusion A -> J. The specialized
inclusion would therefore put an entire coset of an order-five subgroup
inside W_5(F_2), contradicting the exhaustive test.

Thus W_5(Q) is finite. An irreducible rational degree-five divisor cannot
move in a positive-dimensional linear system without giving a degree-five
function: a base divisor would be a proper rational effective sub-divisor
of that irreducible divisor. Since such a function does not exist, only
finitely many degree-five closed points occur on C.

This proof does not use the inconclusive order-two tests at 3 or 5, nor
the longer cyclic-eight test at 7. Replay with Sage's Python:

    sage -python run_43_certificate.py
