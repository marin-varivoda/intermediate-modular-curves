# Intermediate modular curves with infinitely many quintic points

New self-contained implementation started 5 September 2026.

Start with [CLASSIFICATION_TABLE.md](CLASSIFICATION_TABLE.md) for the readable
results, and [STATUS.md](STATUS.md) for the computational work log.
See [REPRODUCING.md](REPRODUCING.md) for the checked/recomputed-result distinction
and replay commands. The classification is complete: exactly 43 strict
intermediate pairs have infinitely many quintic points, and each has a
degree-five function over Q. All other strict pairs have only finitely many.
The X0 and X1 endpoints are included separately. The proof is summarized in
[PROOF_OVERVIEW.md](PROOF_OVERVIEW.md); `final_audit.json` records the final audit.

Scope: classify X_Delta(N) over Q for {±1} contained in Delta contained
in (Z/NZ)^*, with infinitely many closed points of **exact degree five**.
Treat strict intermediate curves as the new work, and incorporate the
X0 and X1 endpoints from their separate classifications.

The [feasibility study](FEASIBILITY.md) is an archived planning document,
not trusted input. No home-directory module or database is loaded.
See `AUDIT.md` for mathematical arguments and outstanding acceptance tests.

New modules:

- `enumeration.py`: integer-only subgroup enumeration and coset signatures.
- `test_enumeration.py`: independent powerset enumeration and basic tests.
- `audit_enumeration.py`: compare with Sage's abstract unit groups and GammaH.
- `canonical_relations.py`: weight-dependent exact q-expansion relations.
- `export_canonical.py`, `verify_canonical_hilbert.m`: general canonical
  model identification by containment and equality of Hilbert polynomials.
  The complete scheme-theoretic argument is in `MODEL_IDENTIFICATION.md`.
- `run_hilbert_models.py`: isolated parallel generation and verification;
  all fifteen models needed for the later exceptional cases passed, including
  genus eleven. Results include source and artifact hashes.
- `export_genus5.py`, `verify_genus5.m`: independent geometric checks
  for the genus-five complete-intersection case.
- `build_inventory.py`: theorem-sourced status ledger; never imports
  previous home-directory classification labels.
- `build_complete_inventory.py`: adds the X0/X1 endpoints and the all-level
  boundary. The checked inventory contains 1,388 subgroup-defined curves
  through level 191; these are not deduplicated by curve isomorphism.
- `canonical_j_map.py`, `export_closed_cusps.m`: exact modular j-functions
  and complete closed cusp support, including non-rational cusps.
- `run_case40_certificate.py`, `run_case48_certificate.py`: full rational
  divisor-class sieves with independently proved torsion bounds.
- `run_family_certificate.py`, `run_family65_certificate.py`: elliptic-family
  finiteness certificates, accepted only after every lifting check passes.

Regenerate the checked ledger and readable tables from this directory:

    python3 audit_results.py --require-complete

This also runs the fast tests. Its component steps are:

    python3 build_inventory.py
    python3 build_complete_inventory.py
    python3 write_classification_report.py

The builders validate certificate hashes. An incomplete computation, a failed
bounded search, or an exploratory lattice calculation is not a certificate.

Run the fast tests with `python3 -m unittest -v`. With a standard Sage
installation run `sage -python audit_enumeration.py --max-level 191`.
The completed independent enumeration audit covers that entire range.
The workstation's `/usr/local/bin/sage` wrapper discards arguments;
on that machine the working command is:

    /opt/sage/bin/conda run --no-capture-output -n sage python audit_enumeration.py --max-level 191

This environment-specific command is not a library dependency. The code
works with a properly configured standard Sage/Python installation.

Prototype model workflow (standard Sage installation):

    sage -python canonical_relations.py 33 --generators 32 2 --output relations_33.json
    python3 export_genus5.py relations_33.json
    magma -b verify_genus5.m

These steps certify exact relations and geometry. RATIONAL_MODELS.md
supplies the rational modular interpretation via mu-model duality.
The default export filename is shared: run exports and their Magma check
sequentially, not concurrently. Production parallel jobs must use isolated
working directories. See AUDIT.md for the mathematical verification gates.

New positive classification certificates: `quintic_33.m`, `quintic_34.m`.
Their mathematical explanations and reproduction commands are in
NEW_RESULTS.md. Bounded unsuccessful searches never update a negative status.

Later certificates are also recorded in `genus5_jobs`, `canonical_jobs`,
and `classification_inventory.json`. The closed-support search at level 48
demonstrates why testing rational-point-supported divisors alone is not
enough: its successful canonical residual uses a quadratic closed point.
See `STATUS.md` for the current ledger, `ELLIPTIC_DEGREE_EXCLUSIONS.md` and
`DEBARRE_FAHLAOUI_OBSTRUCTION.md` for the new uniform finiteness arguments.

External mathematical inputs are explicitly cited in the proof notes.
The completed X0 quintic-point proof and certificates are in `../final/`;
the old home-directory intermediate-curve database is not a dependency.

This folder belongs to the current x0_deg5 repository; it is not a new
nested Git repository and does not replace the existing database.
