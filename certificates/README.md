# Certificates

One folder per result. Every folder has a README that says what is proved, which scripts prove it, and how to
rerun them; saved outputs are kept next to the scripts. `../verify.py` checks all saved outputs against the
tables in `../data/`.

| Folder | Result | Software | Time |
|---|---|---|---|
| `A_x0_quintic/` | Theorem A: the 30 levels $N$ for $X_0(N)$ | Magma | minutes per level |
| `B_intermediate_quintic/` | Theorem B and Corollary E: all 1388 pairs $(N,\Delta)$ with $N\le 191$ | Magma, Sage | see its README |
| `B_class_E_degrees/` | Theorem B, class E: modular degrees of the odd-rank elliptic curves | Magma | seconds |
| `C_intermediate_gonality/` | Theorem C: the 76 strict curves with $N\le 50$ | Magma, Sage | up to an hour per curve |
| `C_43.132.9.a.2/` | Theorem C: the one curve that needs a lifting argument | Magma | minutes |
| `D_x1_gonality/` | Theorem D: $X_1(N)$ for $41\le N\le 50$ | Magma, C++ | up to 30 hours per level |
| `good_reduction.m` | Good reduction (paper, §2.2) of all 67 canonical models and primes used, via Adžaga et al., Lemma 2.3 | Magma | 30 seconds |

`B_intermediate_quintic/README.md` maps every claim of Theorem B to its scripts and saved evidence, including the
hash-named folders of the special curves; its `verify.py` rebuilds the classification of all 1388 pairs from that
evidence.
