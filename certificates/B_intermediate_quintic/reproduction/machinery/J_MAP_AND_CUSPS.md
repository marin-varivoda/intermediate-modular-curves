# Recovering all cusps from the new canonical models

`canonical_j_map.py` constructs j without a home-directory dependency.
For genus g and modular index I, choose k with k(2g-2)-I >= g. Since j
has pole degree I, Riemann--Roch guarantees a nonzero denominator in
H0(kK-div_infty(j)). Canonical projective normality lets us express both
numerator and denominator by degree-k homogeneous polynomials.

We use the standard-monomial basis of the verified canonical ideal, whose
dimension must equal k(2g-2)+1-g. This is much smaller than the space of
all degree-k monomials. The newly computed q-basis is checked against the
certified model's stored basis. We then solve exactly for

    Delta * numerator - E4^3 * denominator = 0.

Both sides are holomorphic modular forms of weight 2k+12 on Gamma_Delta.
Vanishing through floor((2k+12)I/12) proves the identity by Sturm; extra
coefficients are checked too. Thus their ratio is the modular j-function,
not merely a rational approximation to its q-expansion. In the canonical
mu-model this is its corresponding elliptic j-invariant; duality may swap
the two X0 j-maps but preserves the cusp support.

`j_cusp_search.m` independently checks that the pole divisor has degree I
and decomposes its entire support over Q. The resulting cusp degrees
agree with `cusp_arithmetic.py`. That separate integer-only construction
uses primitive columns modulo N, the upper triangular Gamma_Delta action,
and the Galois action (x,y) -> (sigma*x,y). Its geometric cusp total agrees
with the coset enumeration. Tests check the classical X0 cyclotomic
degrees through level 64 and the prime-level X1 formula.

Completed j-map computations include the genus-five level-64 curve and
both remaining genus-seven level-48 curves. At level 64 the pole support
has degrees 1,1,1,1,2,2,2,2,4,4,4. The missing quadratic cusp immediately
gave the quintic witness now isolated in CASE64.md. At level 48, searches
over all effective cusp-supported quintics found no witness; canonical
residual searches are continuing. Such failures are not exclusions.

The j-map discovery artifacts are not needed by the short level-64 proof:
its explicit point coordinates and exact degree-five check are replayed
independently on the certified canonical model.
