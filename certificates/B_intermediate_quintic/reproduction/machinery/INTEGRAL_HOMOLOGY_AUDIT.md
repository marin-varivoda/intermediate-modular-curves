# Integral homology versus isogeny data

The local Magma 2.29-4 source audit found a distinction relevant to torsion.
`JH(N,gens)` in Geometry/ModAbVar/modabvar.m constructs a sequence of
character modular-symbol spaces. The default lattice in homology.m is the
direct sum of their individual integral bases. This does not by itself
identify the gluing between character components in H_1(X_Delta,Z).

In contrast, the constructor taking a *multi-character modular-symbol
space* has a separate integral-lattice correction using IntegralBasis of
that full space. We are investigating that route and must check that its
lattice is the actual modular-curve homology before using torsion bounds.

The first `hecke_torsion64.m` calculation is therefore EXPLORATORY ONLY.
Its exponent-four output must NOT be imposed on Pic(C)(Q) as a proven
constraint. `cubic_classes64.m` merely explores what that constraint would
do; it is not an exclusion certificate. Neither script feeds the accepted
classification ledger.

The existing accepted JH computations use only dimensions, rational simple
isogeny factors, central L-values, and Frobenius polynomials. These are
isogeny-invariant and do not use this integral-lattice identification.
All accepted finite-field class groups are computed from the independently
verified curve function fields, not from JH's homology. In particular the
level-43 translate proof is unaffected.
