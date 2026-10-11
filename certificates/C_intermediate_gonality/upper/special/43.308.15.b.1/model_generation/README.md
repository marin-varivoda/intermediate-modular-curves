# Modular-unit model generation

This directory is a self-contained snapshot of the current code for producing
certified plane models of intermediate modular curves \(X_\Delta(N)\).

It packages the existing model-generation algorithm without changing its
mathematics or adding new model metadata. The only generalization is the
command-line entry point: the level, subgroup generators, label, expected
genus, and output directory are inputs instead of constants for one curve.

## Contents

- `generate_model.sage` is the reusable command-line entry point.
- `modular_units_lib.sage` constructs modular-unit and cusp-divisor lattices
  on \(X_\Delta(N)\).
- `modular_unit_models_v4.sage` selects two modular units, finds their plane
  relation, and certifies birationality.

The two library files are exact copies of the versions previously used from
`modular_unit_upper_bounds/model_computation/`.

## Usage

Run the generator from anywhere by supplying all curve-specific data:

```sh
sage model_generation/generate_model.sage \
  --label 43.308.15.b.1 \
  --level 43 \
  --delta-generators 42,6 \
  --expected-genus 15 \
  --output-dir gonality_43_308_15_b_1
```

If Sage is not on `PATH`, the repository's current conda environment can be
used by replacing the first line with:

```sh
conda run -n sage_env sage model_generation/generate_model.sage \
```

The subgroup generators are interpreted by the existing code as generators of
\(\Delta\leq(\mathbf Z/N\mathbf Z)^\*/\{\pm1\}\).

`--expected-genus` is recorded in the metadata but is not checked by this
script. Genus verification remains a separate normalization computation.

## Current algorithm

For the requested \(N\) and \(\Delta\), the code:

1. Computes the closed cusp labels of \(X_1(N)\), their \(\Delta\)-orbits, and
   ramification in \(X_1(N)\to X_\Delta(N)\).
2. Constructs the exact lattice of rational modular units descending to
   \(X_\Delta(N)\), represented both by cusp divisors and by monomials in
   \(F_2,\ldots,F_{\lfloor N/2\rfloor+1}\).
3. Searches for low-degree units and chooses two candidates \(X\) and \(Y\).
4. Computes exact cyclotomic \(q\)-expansions at the standard cusp.
5. Finds a relation \(P(X,Y)=0\) by exact linear algebra.
6. Certifies the relation using a global pole-degree bound.
7. Certifies birationality from irreducibility and the degree equalities
   \(\deg_Y(P)=\deg(X)\) and \(\deg_X(P)=\deg(Y)\).

## Outputs

The selected output directory receives:

- `model.m`, containing the affine plane equation in Magma syntax;
- `model_metadata.json`, containing the curve inputs, library version,
  birationality flag, degrees and \(F_k\)-monomial expressions of \(X,Y\), and
  their divisors on the closed cusp orbits.

Existing files with these names are overwritten, matching the behavior of the
original case-specific generator.

## Current limitations

This snapshot intentionally does not yet add:

- explicit cusp points or branches on the normalized plane model;
- local expansions at all cusps;
- an explicit map from a model of \(X_1(N)\);
- the \(j\)-map;
- maps to \(X_0(N)\) or other modular quotients;
- parametrizations of elliptic quotients.

Those features should be designed separately after this baseline module has
been validated.
