# Feasibility and proposed plan

Date: 5 September 2026. This is a planning assessment, not a new proof.
Only existing files and literature were inspected; no Sage/Magma searches
or inventory-generation scripts were run.

## 1. Bottom line

This is a strong and realistic next project. We already have much more
than a gonality database: the home-directory repository contains an
initial quintic classification study with an inventory, candidate
partition, explicit functions, finite-field tests, and a report identifying
its unfinished steps.

The right project is **finish and audit that classification**, adapting
our X0 methods, rather than calculate every intermediate gonality anew.
The likely difficult part is rational divisor-class geometry and complete
elliptic-map exclusions, not brute-force curve generation.

Our completed X0 result removes a large block immediately. Using the
counts in the existing report, the initial 338 strict candidates become
204. Its list of 13 hard quartic-dense cases becomes 11, since the curves
over X0(89) and X0(101) are now excluded by projection. However, this is
**not yet an eleven-case proof project**: the broader minimum-density-five
branch still has an explicitly unfinished uniform audit.

## 2. What exists in the literature

- Derickx–Orlić classify quartic-dense intermediate curves. Their
  introduction explicitly discusses the quintic extension and why
  smaller-degree families and abelian subvarieties complicate it.
  [Paper](https://arxiv.org/html/2504.15937v1).
- Orlić already classifies strict intermediate curves of rational
  gonality five globally, not just up to level 50. There are four,
  at levels 31 (two subgroups), 44, and 125. These are immediate positive
  cases by Hilbert irreducibility.
  [Gonality paper](https://arxiv.org/abs/2407.14512).
- Kadets–Vogt give the structural results for small minimum density
  degree, including exceptional Debarre–Fahlaoui geometry.
  [Paper](https://arxiv.org/abs/2208.01067).
- Derickx–Hwang–Jeon–Orlić provide the published X0 quintic classification
  with its former thirty exceptions; our `../final/` supplies those
  remaining cases. [Paper](https://arxiv.org/html/2503.08975v2).
- The X1 endpoint problem for degree five is already covered by
  Derickx–Sutherland, *Torsion subgroups of elliptic curves over quintic
  and sextic number fields*, Proc. AMS 145 (2017), 4233–4245, referenced
  in the quartic paper. Import its exact-degree statement separately.

The quartic authors' [reproduction repository](https://github.com/nt-lib/quartic-Xdelta)
includes degree-pairing work for elliptic targets, with separate treatments
of multiplicity two and other cases. This is the natural starting point
for excluding degree-five elliptic maps.

I did not locate a published complete classification of quintic-dense
strict intermediate curves in the searches performed. That is a search
finding, not proof that nobody is working on it. Before a major campaign,
ask Derickx and Orlić whether there is an unpublished continuation.

## 3. The decisive reduction from our X0 result

For the finite map u: X_Delta(N) -> X0(N), a degree-five point maps to a
point of degree one or five, by the tower law. Infinitely many source
points have infinitely many distinct images because u has finite fibers.
Thus if X0(N) has finitely many rational points AND finitely many quintic
points, every intermediate curve above it has finitely many quintic points.

All thirty newly resolved X0 curves have genus greater than one, so this
applies to them. The same reasoning excludes the published negative
levels, checking finiteness of rational points when applying the rule.
Do not silently replace this argument with the generally false assertion
that every quintic point maps to a quintic point.

Consequently the level search is finite and can be restricted to the
positive X0 list (whose maximum is 125):

    1–45, 47–58, 61, 63, 64, 65, 67, 68, 72, 73,
    75, 80, 81, 91, 109, 121, 125.

The list is from the X0 paper's Theorem 1.10, combined with our negative
results. A positive base curve does NOT prove that a cover is positive.
Apply the same negative-projection filter along the entire subgroup
lattice, and to useful lower-level degeneracy maps, whenever the target
has finitely many rational and quintic points.

## 4. Existing local work and its reliability

The key source is:

    /home/mvarivoda/intermediate_modular_curves/degree5_points_intermediate/REPORT.md

Its recorded partition, and the arithmetic consequences of removing the
134 candidates above our thirty levels, are:

| Branch | Earlier inventory | After the X0 exclusions |
|---|---:|---:|
| Strict candidates | 338 | 204 |
| Already quartic-dense | 54 | 52 |
| Not quartic-dense | 284 | 152 |
| Explicit open cases in quartic-dense branch | 13 | 11 |

These updated numbers are deductions from the archived report, not a
newly regenerated subgroup census. Phase 1 must reproduce them and check
identifiers. Within the retained quartic-dense branch, the report records
35 positive cases and six negative cases, leaving eleven. It also records
the four globally pentagonal positives in the other branch. These earlier
certificates should be audited before being promoted to final theorem rows.

The gonality dataset records all **76 strictly intermediate curves** with
N <= 50 as having exact rational gonality. Including endpoints, it contains
171 rows, of which 161 have proved exact values; the ten X1 entries at
41 <= N <= 50 are marked upper bounds conjectured exact. Use proof-status
fields, not the numerical pattern-search column.

The existing quintic report expressly says its uniform pentaelliptic
exclusion has not been fully recorded. Its nonquartic rows are labeled
`mdd5_analysis`, not completed negative certificates. This is the main
reason not to declare everything outside the eleven-row list settled.

## 5. The mathematical work splits naturally into two branches

### A. Curves not already dense in degrees below five

Use the published lower-degree classifications to certify that this
branch really has finitely many points of each degree 1–4. In this
specific intermediate family the quartic classification incorporates
the lower-degree positive cases; this implication is not a general
principle about curves.

For genus at least 12, minimum density degree five forces a degree-five
map to P1 or a positive-rank elliptic curve, by the Kadets–Vogt bound
(also stated as Corollary 2.5 in the quartic paper). The P1 possibilities
are already classified. The remaining uniform task is therefore:

1. Determine all relevant rational elliptic factors, including old factors.
2. Compute the FULL integral lattice of maps and its degree pairing.
3. Test whether degree five is represented, over every relevant rational
   isogeny target, accounting for kernels and saturation.
4. Save a proof of completeness, not just the failure of obvious maps.

For a positive elliptic map, lower-degree finiteness ensures that infinitely
many rational fibers yield irreducible degree-five divisors. Outside this
branch, do not assume irreducibility merely from positive rank.

Genera at most 11 need their own coverage table. The local study singles
out `43.132.9.a.2` as a plausible exceptional case and records an empty
elliptic-coset test at p=3. Recheck that certificate and the claim that it
is the only exception. In particular, distinguish rational minimum density
from geometric/potential minimum density before invoking a refined
Debarre–Fahlaoui classification; verify all descent hypotheses. Do not
use a geometric classification as an automatic rational classification.

**Feasibility:** good prospect for a largely uniform proof, but the
elliptic-map lattice audit is a genuine mathematical deliverable.

### B. The eleven explicit quartic-dense leftovers

Knowing gonality four does not answer the exact degree-five question.
First seek a genuine degree-five function; otherwise use rank-zero
specialization or control abelian translates in W5, as for X0.

Generators below are residues modulo N, copied from the earlier report.
Rank-zero status is inherited from that report, not newly computed.

| N | Generators of Delta | Genus | First approach | Assessment |
|---:|---|---:|---|---|
| 33 | 32, 2 | 5 | Rational quintic pencil classes; two-prime lifting | Relatively favorable |
| 34 | 33, 9 | 5 | Same; recorded rank zero | Relatively favorable |
| 35 | 34, 4 | 5 | Same; recorded rank zero | Relatively favorable |
| 41 | 40, 2 | 5 | Same; recorded rank zero | Relatively favorable |
| 48 | 47, 5 | 7 | Rank-zero specialization and local W5^1 geometry | Moderate |
| 53 | 52, 4 | 8 | Double-cover obstruction, then positive-part W5 sieve | Moderate |
| 61 | 60, 3, 4 | 8 | Quotient geometry and W5 translate sieve | Moderate |
| 65 | 64, 2, 7 | 9 | Elliptic factors and known fixed-divisor families | Moderate–hard |
| 65 | 64, 3 | 11 | Same, with larger finite Jacobians | Harder |
| 65 | 64, 4, 6 | 11 | Same; share arithmetic across level 65 | Harder |
| 75 | 74, 4 | 9 | Establish positive-part decomposition first | Moderate–hard |

The old report says small reductions of the five rank-zero curves do
admit degree-five functions. Therefore a repeat of an empty finite-field
function test is unlikely to suffice. The actual problem is rational
lifting of special divisor classes. This makes them favorable in size,
but not automatic.

For the other six, adapt the X0 empty-coset, quotient-label, and tangent
methods. Retain all possible positive-rank factors, repeated isotypic
directions, and rational torsion in rank-zero quotients. A surviving
family of reducible divisors must be explained, not counted as quintic
points. A missing degree-five function is only the first half of a
negative proof at positive rank.

## 6. What transfers from X0, and what does not

Transfers well: exhaustive degree-five place enumeration; class-group
coset tests; Riemann–Roch and Petri tangent calculations; local rigidity;
rank-zero pencil lifting; the fixed-divisor/Mordell–Lang conclusion.

Needs adaptation: constructing canonical models and their rational
quotient maps; diamond-operator actions; identifying actual embedded
abelian factors and good reductions. Intermediate Jacobians can contain
nontrivial-character constituents not visible in J0(N). Do not reuse the
X0 factor list or assume every X0 Atkin–Lehner action lifts to a chosen
Delta. Verify a rational cusp/base class on each model, and keep torsion
and tangent arguments valid at the selected prime.

For genus-five rank-zero cases, adapt to several moving pencil classes
and possibly larger W5^1 tangent spaces rather than assuming the
one-dimensional local pattern from 77, 85 and 88.

## 7. Proposed execution order

1. **Inventory and audit first.** Pin the existing database/code versions;
   incorporate the X0 result; regenerate the 204-row inventory; attach
   subgroup elements, genus, cover degrees, rational cusp, proof-status
   fields and source references. Audit earlier positive/negative claims.
2. **Close the uniform branch early.** Adapt and certify the elliptic
   degree-pairing sweep; explicitly dispose of every low-genus case.
   In parallel later, small independent rank-zero jobs can proceed.
3. **Solve 33, 34, 35, 41, then 48.** Search exact degree five, enumerate
   special classes, compare rational torsion images at several good
   primes, and lift or exclude. Preserve explicit functions when found.
4. **Solve 53 and 61.** Use them as intermediate-curve prototypes for
   the X0 translate machinery.
5. **Handle the three level-65 curves together, then 75.** Share models,
   quotient maps and factor data, and propagate negative results through
   covers where justified.
6. **Assemble the classification.** Include X0/X1 endpoints separately,
   list every positive (N, Delta), group negatives by uniform method,
   and produce a self-contained proof/certificate folder like `../final/`.

Success criterion: every candidate has a complete positive or negative
certificate AND the all-level elimination is written down. A list of
successful searches or an unresolved elliptic sweep is not completion.

## 8. Resources and expected scale

The 32-core, roughly 512-GB workstation is well suited to independent
curve/prime tasks. Start future batches conservatively (8 workers), then
increase after measuring peak memory. Share cached place and quotient
data; do not assume a single Magma class-group computation uses 32 cores.

Most explicit leftovers have genus 5–11, below the largest X0 cases we
handled. That is encouraging, but genus alone does not predict difficulty:
torsion identification, map-lattice saturation and many surviving pencils
can dominate. Use quotient arguments before constructing large models in
the 152-row structural branch.

Planning estimate, not a runtime promise: inventory/audit is days of work;
the explicit cases and uniform map audit are plausibly a several-week
research project, with a months-scale tail if a descent or exceptional
geometry issue survives. No experimental timing was performed here.

Recommendation: proceed, with the first milestone being a certified
reduced inventory plus the completed pentaelliptic sweep. The new X0
classification makes the project substantially smaller, and the existing
local study gives an unusually strong head start.
