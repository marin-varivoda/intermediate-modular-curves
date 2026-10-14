# X_1(47) over F_2: an earlier run with a different Phase 1 driver

This is the record of an earlier computation for N = 47, p = 2, d = 28, made on 30 September - 1 October 2026
with a different Phase 1 driver (an earlier version of our code that splits the places among four Magma
processes by their roots, `export_uncapped.py`, `merge_snapshot.py`) and an earlier build of the Phase 2 program.
In both runs the expansions themselves are computed by CurveArith.
It was run on the same machine and with the same Magma version (V2.29-4) as the run in `../x1_47/`.

Its result, `phase2.json`, agrees with `../x1_47/phase2.json`: no function of degree at most 28, after testing
651,609,964 divisors (`covers`, equal to `expected_covers`), with the same place counts (`pipeline.out`).

Only the small files are kept: the drivers and logs of the four Phase 1 processes (`parts/`), the merge record
(`pipeline.out`, with SHA-256 hashes of the exported expansions) and the final output. The exported expansions
themselves (about 80 MB) are not included, and the scripts refer to paths and helper modules of the working
repository in which they ran, so this folder is a record, not a rerunnable certificate. The certificate for
Theorem D is `../x1_47/`.
