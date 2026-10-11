# Mathematical audit ledger

New implementation: no imports or numerical facts from the home database.
The earlier feasibility counts are predictions to check, not test oracles.

## Enumeration and geometric signatures

1. Delta is a subgroup of the unit group modulo N containing -1.
   Start with <-1> and adjoin every possible unit to every discovered
   subgroup. Every subgroup has a finite generating set, so induction
   on that set proves completeness. Store full sorted element sets;
   do not identify groups solely by chosen generators or genus.
2. Left cosets Gamma_Delta \ SL2(Z) correspond to primitive bottom
   rows (c,d) modulo N, up to multiplication by Delta. Reduction of
   SL2(Z) onto SL2(Z/NZ) is surjective. Two matrices with bottom rows
   differing by a Delta scalar differ on the left by Gamma_Delta.
3. Delta acts freely on primitive rows: a*c=c and a*d=d imply a=1
   modulo N because c,d generate the unit ideal. Hence the index is
   N^2 product_(q|N)(1-q^-2)/|Delta|.
4. Right multiplication by S and T gives (d,-c) and (c,c+d).
   Because -1 is in Delta, S has order dividing 2 and ST order
   dividing 3. Their fixed-point counts are e2 and e3. T cycles are
   the geometric cusps and their lengths the cusp widths.
5. The orbifold Euler characteristic gives
   g=1+index/12-e2/4-e3/3-cusps/2.
   Check integrality, nonnegativity, permutation relations, transitivity,
   and the independent index product formula.
6. Cross-check every signature and the complete subgroup list against
   Sage's standard GammaH and abstract unit-group implementations.
   This is implementation independence, not independence from all CAS
   mathematics. Standard-library enumeration itself does not need Sage.

References: Sage's official GammaH and arithmetic subgroup documentation:
https://doc.sagemath.org/html/en/reference/arithgroup/sage/modular/arithgroup/congroup_gammaH.html
https://doc.sagemath.org/html/en/reference/arithgroup/sage/modular/arithgroup/arithgroup_generic.html

Important limitations: these are geometric cusp counts, not cusp fields.
Different subgroup presentations can define isomorphic curves; retain
all (N,Delta) pairs until any identifications are explicitly proved.

## Exact relations and first geometric check

`canonical_relations.py` constructs the full Sage weight-two cusp space
for GammaH and compares its dimension with the independent genus. A
degree-d polynomial in these forms has weight 2d. Vanishing through
floor(2d*index/12) certifies identical zero by the valence/Sturm bound.
The code checks extra coefficients but does not confuse those with the
proof bound. The level-33 example has product ranks 12 and 20 in
degrees two and three, respectively.

`verify_genus5.m` independently verifies that the three resulting
quadrics cut out a smooth complete intersection of degree eight and
genus five. The quadratic product rank 12 excludes hyperellipticity:
for a hyperelliptic genus-five curve that rank would be 9. Thus the
canonical map embeds, and its degree-eight image is the whole smooth
complete intersection. This certifies the complex modular curve.

Rational Fourier
coefficients at infinity do not automatically give the point-marked
moduli model over Q: infinity on that model need not be rational.
Conrad's q-expansion notes explicitly explain this issue:
https://math.stanford.edu/~conrad/248BPage/handouts/qexp.pdf
RATIONAL_MODELS.md now supplies the mu_N-marked dual moduli interpretation
and its Q-isomorphism with the intended point-marked quotient. It does
not assume the rational structures agree under the analytic identity.

## Remaining model-generation acceptance criteria

- Specify the rational modular-curve convention and rational descent.
- Compute the full weight-two cusp-form space, including all characters
  trivial on Delta; match its dimension with the independent genus.
- Certify q-expansion relations using a sufficient Sturm bound for the
  relevant weight and group, not an arbitrary fixed precision.
- Check dimension, degree, geometric integrality, smoothness or
  normalization, and equality with the predicted genus.
- Prove that the modular parametrization is birational; matching genus
  or a few point counts alone does not identify a model.
- Treat hyperelliptic, trigonal, genus-zero and genus-one cases explicitly;
  quadrics alone are not a universal canonical-model algorithm.
- Verify maps by substitution and their degrees by function-field
  extensions; verify compatibility with the modular actions.
- Certify good reductions before finite-field divisor computations.

## Classification acceptance criteria

Keep separate: exact degree-five functions; quintic-density status;
gonality bounds; rank-zero results; and geometric versus rational facts.
No unresolved rank, saturation, descent, or model check may be silently
upgraded to a theorem. Earlier home-directory results require new proofs
or independently rerun, audited certificates before acceptance.

## Spectral gonality filter

For a congruence modular curve of PSL2 index mu, the spectral gonality
bound gives gon_C >= 119*mu/12000 (Orlic, *Tetragonal intermediate
modular curves*, Theorem 3.16, https://arxiv.org/abs/2407.14512).
Frey's necessary bound for infinitely many points of degree at most d
is gon_Q <= 2d; see the statement and reference in Section 1 of
https://arxiv.org/html/2504.15937v1.
Since gon_Q >= gon_C, the strict integer test 119*mu > 120000 excludes
infinitely many points of degree at most five, and hence exact degree
five. It also excludes degree-five functions. All groups contain -1,
so the enumerated SL2 index equals the required PSL2 index.
