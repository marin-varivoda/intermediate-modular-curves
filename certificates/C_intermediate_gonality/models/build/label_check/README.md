# LMFDB label check

The labels for our 76 curves came from the old repository's LMFDB matching. For 5 of them
(28.96.4.c.4, 36.144.3.c.1, 40.144.7.fs.1, 48.384.19.bc.1, 48.384.19.bj.1), the group stored by the
LMFDB is not literally {(a b; 0 d) : a ∈ Δ}, so they looked suspicious.

**Resolution:** all 76 labels are correct.
- `conj_stored.m`: for every curve, the LMFDB group for its label (generators saved in
  `lmfdb_stored_generators.json`, downloaded from the LMFDB in July 2026) is conjugate in
  GL₂(Z/NZ) to H_Δ. Magma `IsConjugate`: 76/76.
- `conj_control.m`: every curve is tested against all stored LMFDB groups with the same level, index
  and genus. Each matches exactly its own label (76/76). For the 10 curves that have a sibling with
  the same invariants, including 48.384.19.bc.1 and bj.1, the sibling does not match.

The five were only different representatives of the same conjugacy class.
`labels.json` maps each (N, Δ) to its verified label; it is used by `../build_models.py`.
The LMFDB API is rate-limited: use the saved generators rather than re-downloading.
