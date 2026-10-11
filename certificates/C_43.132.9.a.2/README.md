# The curve 43.132.9.a.2 has $\mathbb Q$-gonality 7

This is $X_\Delta(43)$ with $\Delta=\langle -1,2\rangle$, of genus 9 (paper, Proposition 4.1). The
finite-field bound is weaker here: over $\mathbb F_3$ the curve has gonality 6, but its unique class of
degree-6 pencils does not come from $\mathbb Q$. The proof is written out in
`gonality_43_132_9_a_2_lower_bound.tex`.

| Script | What it checks |
|---|---|
| `identify_model.m` | The LMFDB canonical model used below is isomorphic over $\mathbb Q$ to the MD Sage model of $X_\Delta(43)$ (`mdsage_43.132.9.a.2.m`), by an explicit linear map checked exactly. The map was found by matching points over $\mathbb F_{101}$ and $\mathbb F_{103}$. |
| `torsion_classes.m` | The differences of the three rational cusps are torsion in $J(\mathbb Q)$, by exhibiting principal divisors directly over $\mathbb Q$. |
| `audit_smooth_reduction.m` | Good reduction at 3: arithmetic genus equals geometric genus for the reduced curve. |
| `audit_torsion_counts.m` | The bound 532 on the order of the rational points of the complement of the elliptic factor, from point counts at good primes. |
| `audit_certificate.m` | Cross-checks: identification of the cusps, the elliptic quotient, and the factor computations. |
| `prove_lower_bound_7.m` | Over $\mathbb F_3$ the only $g^1_6$ class lies outside the reduction of $J(\mathbb Q)$ (elliptic part plus cuspidal torsion), so there is no rational function of degree 6. |
| `prove_upper_bound_7.m` | A divisor of degree 7 supported on cusps and elliptic fibres with $h^0=2$. |

```sh
./run.sh          # all scripts in order (minutes); outputs in out/, summary in run.log
```

`lmfdb_43.132.9.a.2.m` and `lmfdb_model0.m` are the LMFDB data (downloaded 12 July 2026).
`references/` keeps the external files that were consulted, with their sources.
