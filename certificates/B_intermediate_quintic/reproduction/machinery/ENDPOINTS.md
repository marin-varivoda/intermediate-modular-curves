# Including the X0 and X1 endpoints

The new calculations concern strict intermediate groups. The requested
classification also includes the two endpoints; they must not disappear
merely because the strict-curve enumeration omits them.

For X0(N), `build_complete_inventory.py` uses the same positive-level list
as the strict ledger. Its sources are DHJO Theorem 1.10 together with the
completed thirty-level proof in `../../../A_x0_quintic/`. The existing strict ledger
already uses precisely this classification for projection exclusions.

For X1(N), the positive levels for exact degree five are

    {1,...,25} minus {23}.

The input is Derickx--Sutherland, Theorems 1.1 and 4.1:
[Torsion subgroups of elliptic curves over quintic and sextic number fields](https://math.mit.edu/~drew/proc13605.pdf).
Theorem 1.1 gives the infinite quintic torsion groups. For each listed
cyclic group, the marked elliptic curves give infinitely many points of
X1(N) with residue degree dividing five. If the genus is positive,
Theorem 4.1 gives rank zero and hence only finitely many rational points,
so infinitely many of these points have degree exactly five. In genus
zero, the rational cusp identifies the curve with P1, which directly has
infinitely many degree-five points. Conversely, infinitely many noncuspidal degree-five points of
X1(N) give infinitely many j-invariants with N-torsion over quintic fields.
Uniform boundedness and the finite list of possible full torsion groups
then give one full torsion group occurring infinitely often. Every cyclic
subgroup order of a group in their quintic list lies in the set displayed
above. Thus no other N is possible. Cusps contribute only finitely many
points. Low-genus rational cases also directly admit a degree-five map.

Their Theorem 4.1 proves rank zero of J1(N) for N<=36. Consequently the
positive endpoints also admit an exact degree-five function by their
Corollary 2.4. These are published inputs, explicitly separated from our
new witnesses for strict intermediate curves.

The combined inventory checks all 1,388 subgroup-defined curves through
191, keeping the full subgroup as identifier and merging coincident
endpoints only when the two classifications agree. For N>=192, the X0
projection exclusion applies to every intermediate group (including X1).
The combined report remains INCOMPLETE while any strict curve is unresolved.
