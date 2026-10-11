# Van Hoeij degree-15 point and its descent

The source is Mark van Hoeij's database at
<https://www.math.fsu.edu/~hoeij/files/X1N/LowDegreePlaces>.  The multi-megabyte
database is not duplicated here: the relevant record is encoded exactly in
`descend_degree15_place.sage`.

For `N = 43`, the unique record with `degv = 15` has `degj = 5`.  The script
`descend_degree15_place.sage` evaluates the exact Tate-normal-form modular
units `F_2,...,F_22` at that point and then evaluates the two modular-unit
coordinates of the extended model.

The resulting point on `43.308.15.b.1` is

```
X^5 - 8*X^4 + 23*X^3 - 27*X^2 + 9*X + 1 = 0,
Y = -X^4 + 5*X^3 - 7*X^2 + X + 1.
```

Both coordinates and the `j`-invariant have degree 5, and direct substitution
in the extended plane equation gives zero.  This certifies that van Hoeij's
degree-15 point descends to a degree-5 point on the intermediate curve.

The coordinate polynomial is irreducible modulo `2`, `3`, and `5`.
`match_descended_place.m` identifies its reductions with Magma's degree-5
places:

| prime | place index |
|---:|---:|
| 2 | 9 |
| 3 | 6 |
| 5 | 211 |

At every one of these primes,

```
D = 3*cusp_3 + cusp_4 + P_5
```

has `h0(D) = 2`.  Each of the other six recurring degree-4 cuspidal patterns,
when combined with this particular `P_5`, has `h0 = 1`.

## Characteristic-zero certificate

`certify_degree9_via_differentials.m` proves over `Q` that

```text
D = 3*cusp_3 + cusp_4 + P5
degree(D) = 9
h0(D) = 2.
```

It computes the 15-dimensional holomorphic differential space on the smaller
model.  Local expansions impose three conditions at `cusp_3` and one at
`cusp_4`.  Since Magma's algorithmic coordinates are an extension of `Q(Y)`
with generator `X`, the remaining condition is evaluated directly at the
exact degree-5 coordinates of `P5`.  Expanding the five number-field values
over `Q` gives a 14-row vanishing matrix of rank 8.  Therefore
`h0(K-D)=7`, and Riemann--Roch gives `h0(D)=2`.

The recorded certificate is `degree9_differential_certificate.out`.  Together
with the finite-field gonality-9 lower bound, this proves
`gon_Q(43.308.15.b.1)=9`.

Files:

- `descend_degree15_place.sage`: exact descent and model verification.
- `descend_degree15_place.out`: its certificate output.
- `match_descended_place.m`: finite-field place matching and Riemann--Roch.
- `match_p2.out`, `match_p3.out`, `match_p5.out`: reduction certificates.
- `certify_degree9_via_differentials.m`: preferred characteristic-zero proof.
- `degree9_differential_certificate.out`: recorded exact output.
- `check_candidate_any_prime.m`: reduction check when `P5` splits.
- `candidate_additional_primes.out`: checks at 7, 11, 13, and 17.
- `place_riemann_roch_char0.m`: the deliberately simple characteristic-zero
  `Place` plus `RiemannRochSpace` experiment.  Its output is a local timing
  log and is ignored while the detached computation is running.

For the general method, including degree behavior, chart issues, normalized
place construction, and divisor searches, see
`../../extended_model_generation/PLACE_DESCENT.md`.
