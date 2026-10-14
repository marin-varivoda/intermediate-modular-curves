# Theorem C: gonality of the strict curves X_Δ(N), 41 ≤ N ≤ 50

`../../data/strict_intermediate_N_le_50.csv` lists all 76 strict curves with N ≤ 50 (for N ≤ 40 the values
are Orlić's), with the method for each bound. The curve 43.132.9.a.2 is in `../C_43.132.9.a.2/`.

| Folder | What it proves | How to rerun |
|---|---|---|
| `models/` | MD Sage canonical models (Derickx), one file per LMFDB label; `models/build/` records how they were made (MD Sage run, label check by conjugacy) | `cd models/build; sage -python mdsage_run/run.py ...; python3 build_models.py` |
| `lower/reduction_check.m` | good reduction of each model at the prime used (Hilbert polynomial, irreducible, genus, cusp ∞) | `cd lower; magma -b reduction_check.m` |
| `lower/runs/<label>.p<p>.m` | gon over F_p with CurveArith's `CAGonality`, unchanged | `cd lower/runs; magma -b <file>` |
| `upper/certificates/` | cuspidal divisors with ℓ(D) = 2 (q-expansions from Zywina's package) | `cd upper/certificates; magma -b <file>` |
| `upper/pullback.py`, `pullback.json` | pullback bounds along forgetful maps (MD Sage) | `sage -python pullback.py` |
| `upper/special/` | the two special divisors at level 43 | `cd upper/special/<label>; magma -b certificate.m` |

The longest lower-bound run is 48.384.19.bc.1 at p = 7: 66 to 92 minutes in `CAGonality`, but 3 to 5 hours in
total, because Magma's genus computation for the reduced model is slow, and about 55 GB of memory. All others take at
most 11 minutes. All logs in `lower/runs/` were produced by the committed scripts.
