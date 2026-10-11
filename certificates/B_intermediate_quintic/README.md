# Intermediate modular curves with infinitely many quintic points

This folder is the self-contained presentation package. Start with
`classification.pdf` (source: `classification.tex`); `x0_proof.pdf` is the
companion proof for the thirty formerly unresolved X0 levels.

The classification has **43 positive strict subgroup-defined pairs**.
Each has a rational function of degree exactly five. The proof also gives
the endpoint X0 and X1 lists and explains why all other pairs are negative.
Pairs are not identified merely because their curves are isomorphic.

## Read and check

- `positive_table.tex`: the 43 positive strict pairs.
- `negative_table.tex`: all 154 direct negative assignments.
- `projection_table.tex`: the seven additional intermediate forgetting maps.
- `all_cases.csv`: all 1388 pairs through level 191, with complete subgroups,
  projection targets and proof metadata. The proof handles larger levels
  uniformly by projection to X0.
- `SOURCE_AUDIT.md`: precise published inputs and their hypotheses.
- `REAUDIT.md`: completed review checklist and chronological audit findings.
- `audit_runs/`: fresh computational replay evidence, including independent
  portable replays of all positive batches and twelve exceptional negatives.

From this folder, using ordinary Python 3.9 or newer:

    python3 verify.py

This checks the sealed file hashes, all case assignments and printed tables,
the saved-evidence ledger in an isolated copy, and every required fresh-replay
record. It needs neither SageMath nor Magma. Run without `-O` or
`PYTHONOPTIMIZE`: verification requires assertions and rejects optimization.
These checks support the reviewed mathematical proof; they are not formal
proof-assistant certification or a substitute for reading the arguments.

## Reproduce computations

`reproduction/machinery/` contains the intermediate-curve sources and accepted
evidence. `reproduction/final/` contains the thirty-level X0 proof and its
36 computational certificates. No original repository or home-directory
code is needed. Absolute paths in historical logs are provenance, not inputs.

For fresh computations, follow `reproduction/machinery/REPRODUCING.md` in a
**copy** of the reproduction tree: runs can replace certificates and would
invalidate the sealed distribution. Tested versions are SageMath 10.7 and
Magma V2.29-4. No strace is needed to use the package.

The outer `replay_*.py` scripts retain workstation re-audit provenance;
portable computational entry points are inside `reproduction/`.
`test_portable_special.py` and `test_portable_positive.py` test fresh replays
in isolated copies of the portable bundle.

`make_tables.py` regenerates the tables and CSV from the bundled inventory.
Compile the main TeX with `tectonic classification.tex`, or run
`pdflatex classification.tex` twice. Do regeneration in a working copy.
`PACKAGE_MANIFEST.json` freezes the reviewed distribution; `seal_package.py`
is the maintenance tool used to create it after all verification gates pass.

The separate, unfinished X1(41) gonality research is not part of this package
and is not used in the classification.
