# Data

`strict_intermediate_N_le_50.csv`: one row per strict intermediate curve X_Δ(N) with N ≤ 50 (76 curves).

| column | meaning |
|---|---|
| label | LMFDB label (checked: the group of the label is GL_2(Z/N)-conjugate to H_Δ) |
| N, Delta_generators | level and generators of Δ (with −1) |
| index, genus | index of Γ_Δ(N) in PSL_2(Z) and genus |
| gonality | Q-gonality |
| lower_bound, lower_method, lower_source | lower bound, method (`genus`, `cited`, `cagonality`, `lifting`) and source |
| upper_bound, upper_method, upper_source | upper bound, method (`genus`, `cited`, `pullback`, `cusp_rr`, `special`) and source |

For N ≤ 40 both bounds are Orlić's (Acta Arith. 220 (2025), Theorem 1.2).

`x1_41_50.csv`: Theorem D, one row per level (N = 48 is in `certificates/D_x1_gonality/double_cover_48/`):
genus, prime p, degree d = gonality − 1 excluded over F_p, number of rational places, n = ⌈N_1/(p+1)⌉,
largest place degree R, number of places, baseline b, number of divisors searched, running time, and the result.
