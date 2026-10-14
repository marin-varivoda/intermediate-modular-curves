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

`B_intermediate_quintic/` is a self-contained package with its own verifier and a hash-sealed record of every
run (`audit_runs/`). Its receipts record the paths of the machine on which they were produced. They are left
unchanged, so that the hashes still match.

## Theorem B: the special negative curves

The twelve exceptional negative curves of the paper (codes T, R, C, F; table "The twelve exceptional negative
certificates") and three others have their own certificates in
`B_intermediate_quintic/`. Their working directories are named by a hash of the curve; this table maps them to the
curves. Runners are in `B_intermediate_quintic/reproduction/machinery/`, the inputs and logs in
`B_intermediate_quintic/reproduction/machinery/hilbert_jobs/<hash>/`, and the fresh replays in
`B_intermediate_quintic/audit_runs/special/`.

| Hash | $N$ | $\Delta$ | $g$ | Code | Runner | Replay folder |
|---|---|---|---|---|---|---|
| `82f731393c98cb7c` | 40 | $\langle-1,3\rangle$ | 7 | R | `run_case40_certificate.py` | `torsion40/` |
| `2fea1fad025e6bab` | 48 | $\langle-1,5\rangle$ | 7 | R | `run_case48_certificate.py` | `torsion48_2fea1fad025e6bab/` |
| `efd0600330b90e51` | 48 | $\langle-1,7,17\rangle$ | 7 | R | `run_case48_certificate.py` | `torsion48_efd0600330b90e51/` |
| `1459e19c781c9c0f` | 36 | $\langle-1,17\rangle$ | 7 | T | `run_petri_certificate.py` | `petri_1459e19c781c9c0f/` |
| `577694554b43283f` | 39 | $\langle-1,5\rangle$ | 9 | T | `run_petri_certificate.py` | `petri_577694554b43283f/` |
| `4517e2b49cc674e5` | 75 | $\langle-1,4\rangle$ | 9 | T | `run_petri_certificate.py` | `petri_4517e2b49cc674e5/` |
| `d0a49dd94f1144df` | 43 | $\langle-1,2\rangle$ | 9 | C | `run_43_certificate.py` | `translate43/` |
| `4a0a750d72e5ecf2` | 53 | $\langle-1,4\rangle$ | 8 | F | `run_family_certificate.py` | `family_4a0a750d72e5ecf2/` |
| `dc8a04ecdc10f967` | 61 | $\langle-1,4\rangle$ | 8 | F | `run_family_certificate.py` | `family_dc8a04ecdc10f967/` |
| `ef93d63ca2b377a8` | 65 | $\langle-1,2,7\rangle$ | 9 | F | `run_family_certificate.py` | `family_ef93d63ca2b377a8/` |
| `bd67dfd630eb6c1b` | 65 | $\langle-1,3\rangle$ | 11 | F | `run_family3_certificate.py` | `family3_bd67dfd630eb6c1b/` |
| `5fa08fafc8523084` | 65 | $\langle-1,6\rangle$ | 11 | F | `run_family3_certificate.py` | `family3_5fa08fafc8523084/` |
| `d6111b7c56067f5a` | 64 | $\langle-1,7\rangle$ | 5 | W | `run_case64_certificate.py` | — |
| `d98511aa0f90f7c4` | 35 | $\langle-1,8\rangle$ | 7 | B | — | — |
| `1e5199b136fae728` | 55 | $\langle-1,4\rangle$ | 9 | B | — | — |

Some files in the sealed tree still carry labels from the time they were written, such as the status
`EXPLORATORY_PENDING_LATTICE_AUDIT` in `integral_torsion_probe.json` or "no completeness claim" at the end of
`support_sieve_p3.log` (both for level 40). They were kept unchanged so that the hashes match. The audits they
were waiting for are recorded next to them (`homology_audit.log` and `HECKE_TORSION40.md` in `machinery/`), and the
complete argument is in Section 7 of the paper.
