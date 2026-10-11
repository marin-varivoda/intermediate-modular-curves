# Reproducing the classification

Start with `CLASSIFICATION_TABLE.md`. Its status is generated from the
checked ledger; unfinished experiments cannot supply a negative answer.
The complete inventory includes the X0 and X1 endpoints and distinguishes
subgroups rather than identifying isomorphic curves at different levels.

## Checking saved results

From this directory, with ordinary Python:

    python3 audit_results.py

This runs the fast unit tests, validates the certificates required by the
ledger, and regenerates both inventories and the readable table. To make
an unresolved case an error, use `--require-complete`. A successful hash
check establishes that the saved proof inputs and outputs are unchanged;
it is not a fresh execution of their mathematical calculations.
When all cases are resolved, `--require-complete` also records the successful
final audit in `final_audit.json`. Tested versions are SageMath 10.7 and
Magma V2.29-4.

## Recomputing the main inputs

The commands below use a standard `sage -python` installation. On the
current workstation the working equivalent is
`/opt/sage/bin/conda run --no-capture-output -n sage python`.
Magma must be on PATH. There is no dependency on the old home-directory
curve code or database. The X0 classification in `../final` and the named
published theorems are explicit external mathematical inputs.

| Input | Fresh replay |
|---|---|
| All subgroups and signatures through 191 | `sage -python run_enumeration_replay.py` |
| Fourteen genus-three/four positive cases | `sage -python run_low_genus_audit.py` |
| Initial positives at 33,34,35,41 | `sage -python run_explicit_positive_audit.py` |
| Batch positives at 30,32,39,40,45 | `sage -python run_batch_positive_audit.py` |
| Further positives at 40 and 48 | `sage -python run_last_positive_audit.py` |
| Direct rank-zero inputs | `python3 run_rankzero_audit.py` |
| Small elliptic-degree/factor inputs | `python3 run_elliptic_input_audit.py` |

The special negative-case runners are `run_case40_certificate.py`,
`run_case48_certificate.py`, `run_petri_certificate.py`,
`run_43_certificate.py`, `run_family_certificate.py`,
`run_family65_certificate.py`, and `run_family3_certificate.py`.
Their command-line docstrings give the required model keys and primes;
the checked inventory gives each curve's complete subgroup and certificate
path. The level-64 positive has its separate `case64_certificate.json`.
These runners check the mathematical prerequisites as well as the final
finite-field or Riemann--Roch calculation.

## Core machinery and its mathematical gates

1. `enumeration.py` enumerates subgroups from integer arithmetic and obtains
   genus and cusp data from coset permutations. `audit_enumeration.py`
   independently compares every subgroup and signature with Sage.
2. `canonical_relations.py` uses the entire weight-two cusp space. It proves
   polynomial relations by a weight-dependent vanishing bound.
   `export_canonical.py` and `verify_canonical_hilbert.m` identify the
   canonical model as a scheme, using containment and equal Hilbert
   polynomials. The rational convention is proved in `RATIONAL_MODELS.md`.
3. Positive witnesses are accepted only after an exact pole-degree check
   or a proved low-genus/published construction. A map of degree four does
   not by itself establish a map of degree five.
4. Negative proofs separate rank-zero divisor-class arguments, uniform
   density/elliptic-degree arguments, and positive-rank elliptic-family
   arguments. Their proof notes state the needed lifting and completeness
   conditions. Neither a failed search nor nonexistence of a degree-five
   function alone is used as a positive-rank finiteness argument.

## Safe parallel execution

Different curves have isolated working directories and may run in parallel.
Do not run two replays for the same curve simultaneously: they can overwrite
each other's inputs or logs. In particular the two level-65 prime variants
share the corresponding rational target directory. Do not edit a source
or proof input while its Magma job is running. After editing a certified
source, rerun every certificate that hashes it; otherwise the ledger will
reject the stale result.

The `*_replays` directories contain accepted replay artifacts only after
a runner writes its certificate. Other directories also retain exploratory
and superseded logs for auditability. Their presence is not evidence of a
proved classification. `STATUS.md` is a chronological work log; the generated
table and checked manifests are the current result.
