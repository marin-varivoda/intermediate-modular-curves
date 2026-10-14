# Thirty remaining quintic-point cases

Start with **quintic_points.pdf**. Its source is **quintic_points.tex**.
The opening table assigns a proof to each of the 30 levels. The rest
explains two shared ideas: exhaustive finite-field sieves and local
rigidity of surviving families.

The result is finiteness of degree-five **closed points** on all 30
curves, and absence of degree-five functions over Q. It is not a list
of those points, nor a claim that no quintic points exist.

## Contents

- `quintic_points.tex` / `.pdf`: consolidated mathematical exposition.
- `code/`: eight entry-point Magma scripts and four shared helpers.
- `logs/`: output of all 36 assertion-based certificates.
- `run.py`: parallel runner and saved-log checker.
- `verification.json`: verification results and SHA-256 hashes.

This directory can be sent on its own. No surrounding repository,
Sage installation, or external GitHub checkout is needed. Magma itself
and its standard databases must be installed.

## Reproduce

Tested with **Magma V2.29-4** and Python 3. From this directory:

```sh
python3 run.py --jobs 8
```

`--jobs 32` runs up to 32 independent Magma processes. These are separate
certificates, not parallel threads within one class-group calculation.
The substantial finite-field checks finished on the scale of minutes
on this workstation; runtime depends on the machine and Magma version.

The runner overwrites the selected logs and `verification.json`.
It checks success markers and errors, since Magma can return exit code
zero after an assertion failure.

To inspect supplied logs without recalculation:

```sh
python3 run.py --check-logs
```

To rerun one case:

```sh
python3 run.py --only translates_145
```

Or, from `code/`:

```sh
magma -b N:=145 translates.m
```

Compile with `pdflatex quintic_points.tex` twice, or with
`tectonic quintic_points.tex`. No external bibliography file is needed.

## What was rechecked

The consolidated scripts were run afresh. They check smooth models,
exact central L-value conditions, Frobenius orders, complete divisor
enumerations, Riemann--Roch dimensions, quotient automorphisms and
tangent ranks. The text explains the deductions from these data.

The audit preserves several important distinctions:

- The X1(32) argument applies directly at 96 and 100, but needs a
  degeneracy-map refinement at 98.
- At positive rank, absence of degree-five functions alone is not
  enough; every such case also has a translate argument.
- At 82, 99 and 128, the known elliptic direction allows arbitrary
  lifts within it, including p-primary points.
- At 131, norms recover the actual elliptic subgroup, not the full
  5-primary subgroup.
- At 83, an extra surviving translate has a verified fixed cubic
  divisor; it is not discarded as a sieve artifact.
- At 145, one order-two tangent test handles both possible positive
  simple factors; a separate surface calculation is unnecessary.

Inputs not proved by the code are stated in the document: standard
modular-curve facts, Mordell--Lang, the modular L-value nonvanishing
theorem, Castelnuovo--Severi, and published gonality results for five
specified levels. The local lifting lemma is proved in the text.
This is a reproducible computational proof, not a formal-proof-assistant
verification or an independent peer review.

## Relation to the paper

`quintic_points.pdf` is a longer write-up of Section 6 of the paper, level by
level. The paper (`paper/main.pdf`) is the authoritative statement of the
arguments; where the two differ in wording, follow the paper.
