# New classification results

These results use only the new machinery, not certificates or status labels
from the home-directory project.

## Level 33, Delta = <-1,2>

The independently enumerated subgroup is
{1,2,4,8,16,17,25,29,31,32}; its curve has genus five.
The new weight-two computation gives three quadratic relations, with
quadratic multiplication rank 12. Their identities are certified through
the weight-four bound 32. The independent Magma check proves a smooth
degree-eight complete intersection. Thus they give the full canonical
model. RATIONAL_MODELS.md proves its Q-isomorphism with X_Delta(33).

On this model the distinct rational points

    P = [1,1,0,1,0],   Q = [1,0,0,0,0]

give a divisor D=4P+Q. The Riemann–Roch certificate quintic_33.m
constructs a rational function and verifies its pole divisor is exactly D.
Consequently its degree is exactly five. Hilbert irreducibility proves
that X_Delta(33) has infinitely many closed points of degree five over Q.

Reproduction from this directory:

    sage -python canonical_relations.py 33 --generators 32 2 --output relations_33.json
    python3 export_genus5.py relations_33.json --output model_33.m
    magma -b quintic_33.m

The geometric verification can also be rerun with export_genus5.py's
default output followed by verify_genus5.m. Standard Sage environment
instructions are in README.md.

## Level 34, Delta = <-1,9>

The genus-five curve for Delta={1,9,13,15,19,21,25,33} is generated and
identified by the same independent procedure. On model_34.m take

    P = [1,0,1,0,1],   Q = [3,0,2,-1,2].

The certificate quintic_34.m verifies a rational function with exact
pole divisor 4P+Q. This proves infinitely many exact quintic points.
Its relations use weight-four bound 36; geometry_34.log records the
independent smooth complete-intersection check.

## Level 35, Delta = <-1,4>

On the freshly constructed rational canonical model use
P=[0,1,1,0,0] and Q=[0,0,1,-1,1]. The degree-five line bundle
K-P-2Q has two sections. The quotient of the computed basis sections
has pole degree exactly five, verified by quintic_35.m. This proves
infinitely many exact quintic points. The earlier failure of a bounded
effective-divisor search was not a negative result.

## Level 41, Delta = <-1,2>

On model_41.m take P=[0,1,0,0,1]. The same construction with K-3P
gives an exact degree-five function, certified by quintic_41.m.
The model is certified by relations_41.json, geometry_41.log, and the
common rational-descent proof. Thus this case is also quintic-dense.

## Fourteen additional genus-three/four positives

All fourteen tested rows in low_genus_certificates.json pass. Genus-three
rows have 5 as a nongap at the rational Tate cusp; genus-four rows have
quadratic multiplication rank nine and hence a basepoint-free K-P of
degree five. LOW_GENUS.md proves the deductions. These are new checks,
not imported home-directory positive statuses.

## Five further genus-five positives

The isolated batch in genus5_jobs proves exact-degree-five functions for
N30_d2, N32_d4, N39_d2, N40_d2 and N45_d2. The suffix records the
degree to X0, but curve.json in each directory records the full subgroup
and is the authoritative curve identifier. Relations, geometric checks,
and successful characteristic-zero function searches are saved there.
Each result.json binds the certificates to hashes of the new source code.
The ledger checks those hashes before accepting a positive.

The same searches at N48_d2 and N64_d2 found no witness and are left
unresolved. They are not finiteness proofs.

## Twenty-five new uniform exclusions

The fresh central-value sweep through level 50, combined with the primary
published gonality classification, proves 25 further finiteness results.
The proof is in UNIFORM_EXCLUSIONS.md. The ledger gives each individual
subgroup and the method FINITE_BY_RANK_ZERO_AND_GONALITY.
