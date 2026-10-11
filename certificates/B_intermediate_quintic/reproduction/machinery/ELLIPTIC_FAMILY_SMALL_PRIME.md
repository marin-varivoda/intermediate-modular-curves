# Optional small-prime version of the elliptic-family criterion

This note is a mathematical extension, not by itself a classification
certificate. Acceptance requires `run_family3_certificate.py` to finish
and emit its hash manifest. The level-65 prime-seven replays use the original
criterion in `ELLIPTIC_FAMILY_CERTIFICATE.md` without modification.

The hypothesis that p does not divide #E(F_p) in that criterion is stronger
than needed. Retain good reduction and p not dividing the degree four of
f:C -> E. The same three finite-field checks suffice even if p divides
#E(F_p).

Indeed, the image A of the pullback on Jacobians is a smooth elliptic
subgroup over Z_p: the identity f_* f^*=[4] makes its kernel prime to p.
Every b in A(F_p) lifts to some a_b in A(Z_p), by smoothness and Hensel
lifting. These lifts need not be torsion and need not form a subgroup.
Define T to be the intersection of the translates W5-a_b. An A-translate
contained in W5 is contained in every W5-a_b, and hence in T. The known
surface Z=A+C is likewise contained in T, because it is stable under all
translations by A. Reducing the defining intersection gives exactly the
same finite-field coset and tangent tests as before.

At a rational reduction point, a parametrized branch of Z has completed
local ring Z_p[[u,v]]. The immersion test and the two-dimensional tangent
bound for T identify T with that branch by the formal implicit function
argument in the original proof. No step requires the chosen lifts to
form a finite subgroup. The remaining Mordell--Lang and irreducible-divisor
arguments are unchanged.

For level 65, prime 3 is thus permissible in principle. Nevertheless,
one must first certify good integral models and the forgetting/Fricke
maps in coordinates that reduce correctly at 3. One must then recompute
all fibers, the entire elliptic subgroup, every effective degree-five
class, all tangent bounds, and immersion. Smaller-field output alone
does not certify the characteristic-zero conclusion.

The transformed models in `family3_jobs` are produced
by exact invertible coordinate changes from the certified new models;
`prepare_family3_models.py` checks the transformed forgetting-map identity
beyond the Sturm bound. Separate good-reduction checks are essential.
No row in the inventory is changed by this note or by exploratory output.
The full replay additionally checks the original rational models and map,
the elliptic quotient and its proven rank, the full source factor profile,
and all finite-field conditions before writing `certificate.json`.
