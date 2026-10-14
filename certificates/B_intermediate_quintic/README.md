# Theorem B: strict intermediate curves with infinitely many quintic points

The proof of Theorem B and Corollary E is Section 7 of the paper (`../../paper/main.pdf`); it is the authoritative
statement of every argument. `classification.pdf` (source `classification.tex`) is a longer write-up of the same
case analysis. This folder holds the evidence for the computational steps.

## Check

    python3 verify.py        # about 20 seconds; standard Python only

This rebuilds the classification of all 1388 pairs $\{\pm1\}\subseteq\Delta\subseteq(\mathbb Z/N\mathbb Z)^\times$ with
$N\le191$ from the saved evidence, in a temporary copy, and checks it against `all_cases.csv` and the four tables
(`positive_table.tex`, `negative_table.tex`, `special_table.tex`, `projection_table.tex`). The rebuild
(`reproduction/machinery/build_inventory.py`):

- recomputes the census of the 1388 pairs (index, genus, cusps, elliptic points) in pure Python and compares it with
  the census made with Sage (`enumeration_audit_191.json`);
- applies the arguments of Section 7 in order, and for each computational argument checks the saved evidence of that
  curve, as described in the table.

What is checked for each class is listed in the last column of the table below. The rebuild does not rerun Sage or
Magma (see "Rerunning"), and it does not check that the scripts are the ones that produced the evidence: the
certificates record hashes of their outputs, which are checked, and the scripts are tracked by git. Theorem A, used
for the projections to $X_0(N)$, is checked separately (`../A_x0_quintic/run.py --check-logs`; the top-level
`verify.py` runs both). `make_tables.py` regenerates the tables and `all_cases.csv` from the inventory.

## Claims and evidence

All paths below are relative to `reproduction/machinery/` (the folder name is kept from the first version of the
paper). Codes are those of the paper.

| Claim | Curves | Argument | Script(s) | Evidence (what the rebuild checks) |
|---|---:|---|---|---|
| Census | 1388 pairs, 1011 strict | enumeration of $\Delta$ with genus formula | `enumeration.py`; Sage cross-check `audit_enumeration.py` | `enumeration_audit_191.json` |
| Projection to $X_0(N)$ | 807 | Theorem A and DHJO, Thm 1.10 | rule in `build_inventory.py` | Theorem A, in `../../../A_x0_quintic/` (checked separately) |
| Projection to an intermediate curve | 7 | forgetful map to a negative curve | rule in `build_inventory.py` | the forgetful maps are recomputed from the census (`../../projection_table.tex`) |
| S | 15 | Abramovich + Frey, $119\mu>120000$ | rule in `build_inventory.py` | recomputed from the census |
| L | 13 | genus $\le2$, rational cusp | rule in `build_inventory.py` | — |
| K | 14 | genus 3: 5 is a non-gap at $\infty$; genus 4: not hyperelliptic | `low_genus_certificates.py`, `run_low_genus_audit.py` | `low_genus_certificate.json` (hashes of its logs), `low_genus_certificates.json` |
| W | 12 | explicit pencil of degree 5 | levels 30, 32, 39, 40, 45: `run_genus5_batch.py`; 33, 34, 35, 41: `quintic_*.m`, `run_explicit_positive_audit.py`; 48: `run_closed_support.py`; 40: `run_canonical_search.py`; 64: `run_case64_certificate.py` | success lines of the model and witness logs in `genus5_jobs/`; certificates with log hashes in `positive_replays/` and `hilbert_jobs/d6111b7c56067f5a/`; model and search log in `canonical_jobs/f8e9cf4df1909a47/` |
| P | 4 | Orlić, Thms 1.4–1.5 | — | citation |
| Z | 74 | rank 0 and $\gon_\mathbb Q\ge6$ | `run_rank_zero.py` (`central_value.m` for $J_1(N)$, 25 curves; `intermediate_central_value.m` for $J_\Delta(N)$, 49 curves); `published_gonality.py` | the section of the curve in `central_values.log` / `intermediate_central.log`: its level and subgroup, `central_zero=false` and the success line |
| B | 2 | bielliptic + rank 0 | as Z | as Z |
| T | 3 | Petri lifting | `run_petri_certificate.py`, `verify_petri_lifting.m` | `hilbert_jobs/{1459…,5776…,4517…}/integral_model/petri_certificate.json` (status and log hashes) |
| R | 3 | all of $J(\mathbb Q)$ and a sieve of its classes | level 40: `run_case40_certificate.py`, `integral_torsion_probe.py`, `audit_integral_homology40.py`, `torsion_order_bounds.m`, `rational_support_sieve.m`; level 48: `run_case48_certificate.py`, `pullback_torsion48.py`, `closed_cusp_support_sieve.m` | `hilbert_jobs/82f7…/case40_certificate.json`, `hilbert_jobs/{2fea…,efd0…}/case48_certificate.json` (torsion order, number of classes, log hashes) |
| C | 1 | no coset of $A(\mathbb F_2)$ in $W^0_5(\mathbb F_2)$ | `run_43_certificate.py`, `case43_factors.m`, `test_translate_cosets.m` | `hilbert_jobs/d0a4…/integral_model/certificate.json` (status and log hashes) |
| F | 5 | reducible elliptic families | `run_family_certificate.py` (53, 61), `run_family65_certificate.py` (65⟨−1,2,7⟩), `run_family3_certificate.py` (the two genus-11 curves at 65, $p=3$) | certificates in `family_jobs/`, `family3_jobs/` (status and hashes of their logs and of `forgetting_jobs/`) |
| E | 43 | Kadets–Vogt + degrees of elliptic quotients | rule in `build_inventory.py` | `../../../B_class_E_degrees/modular_degrees.log`: every elliptic curve of odd analytic rank at the level has modular degree > 1; Derickx–Orlić, Cor. 4.10 |
| E0 | 5 | no positive-rank elliptic factor | `elliptic_factors.m` | `elliptic_factors_109.log`, `elliptic_factors_125.log`: level and conclusion |
| D | 3 | Debarre–Fahlaoui configurations excluded | `small_density_elliptic.m` (37, 57), `elliptic_factors.m` (73) | `small_density_37.log`, `small_density_57.log`, `elliptic_factors_73.log`: elliptic curve or level, and conclusion |

The working folders of the special curves are named by a hash of the curve:

| Hash | $N$ | $\Delta$ | $g$ | Code |
|---|---|---|---|---|
| `82f731393c98cb7c` | 40 | ⟨−1,3⟩ | 7 | R |
| `2fea1fad025e6bab` | 48 | ⟨−1,5⟩ | 7 | R |
| `efd0600330b90e51` | 48 | ⟨−1,7,17⟩ | 7 | R |
| `1459e19c781c9c0f` | 36 | ⟨−1,17⟩ | 7 | T |
| `577694554b43283f` | 39 | ⟨−1,5⟩ | 9 | T |
| `4517e2b49cc674e5` | 75 | ⟨−1,4⟩ | 9 | T |
| `d0a49dd94f1144df` | 43 | ⟨−1,2⟩ | 9 | C |
| `4a0a750d72e5ecf2` | 53 | ⟨−1,4⟩ | 8 | F |
| `dc8a04ecdc10f967` | 61 | ⟨−1,4⟩ | 8 | F |
| `ef93d63ca2b377a8` | 65 | ⟨−1,2,7⟩ | 9 | F |
| `bd67dfd630eb6c1b` | 65 | ⟨−1,3⟩ | 11 | F |
| `5fa08fafc8523084` | 65 | ⟨−1,6⟩ | 11 | F |
| `d6111b7c56067f5a` | 64 | ⟨−1,7⟩ | 5 | W |
| `f8e9cf4df1909a47` | 40 | ⟨−1,7⟩ | 7 | W |

Each `hilbert_jobs/<hash>/` holds the canonical model of the curve (`relations.json`, `canonical_input.m`, identified
by its Hilbert polynomial in `geometry.log`); the certificate and its logs are next to it. At level 40 the logs are in
`case40_final_replay/`, at level 48 in `case48_replay/`. Two saved level-40 outputs still carry the labels
`EXPLORATORY_PENDING_LATTICE_AUDIT` and "no completeness claim" from when they were written; the certificate records
their hashes, so they are kept as they are. The lattice audit they mention is `homology_audit.log` in the same folder.

### Where to start reading

- the paper, Section 7, and `negative_table.tex` / `special_table.tex` for the case list;
- `build_inventory.py`: the order in which the arguments are applied, and what is checked for each;
- one certificate per class, for example `hilbert_jobs/82f731393c98cb7c/case40_certificate.json` with
  `rational_support_sieve.m` (R), `hilbert_jobs/1459e19c781c9c0f/integral_model/petri_certificate.json` with
  `verify_petri_lifting.m` (T), `family_jobs/4a0a750d72e5ecf2/certificate.json` with `family_tangent_immersion.m` and
  `finite_elliptic_families.m` (F).

The other scripts in `reproduction/machinery/` build the canonical models (`run_hilbert_models.py`,
`verify_canonical_hilbert.m`, `integral_relations.py`, `export_*.py`, …) and are used by the runners above.

## Rerunning

Requirements: SageMath 10.7 and Magma V2.29-4; scripts that import Sage are run with `sage -python`. Run from
`reproduction/machinery/`. The runners overwrite the saved evidence in place; to compare instead, run them in a copy
of `reproduction/machinery/` (placed so that `../../../B_class_E_degrees/` exists) and compare the logs.

| Class | Command |
|---|---|
| Z, B | `python3 run_rank_zero.py` (about a minute; rewrites `central_values.log` and `intermediate_central.log`) |
| E0, D | `magma -b N:=109 elliptic_factors.m > elliptic_factors_109.log` (also 125, 73); `magma -b N:=37 small_density_elliptic.m > small_density_37.log` (also 57) |
| K | `sage -python run_low_genus_audit.py` |
| W | `python3 run_genus5_batch.py`, `run_explicit_positive_audit.py`, `run_closed_support.py`, `run_canonical_search.py`, `run_case64_certificate.py` |
| T | `sage -python run_petri_certificate.py <hash> --prime <p>` |
| R | `sage -python run_case40_certificate.py`; `sage -python run_case48_certificate.py <hash>` |
| C | `sage -python run_43_certificate.py` |
| F | `sage -python run_family_certificate.py <hash> --prime <p>`; `run_family65_certificate.py`; `run_family3_certificate.py` |
| Census | `sage -python audit_enumeration.py` |

After rerunning, `python3 audit_results.py --require-complete` rebuilds the inventory, `python3 ../../make_tables.py`
the tables, and `python3 ../../verify.py` checks the result.
