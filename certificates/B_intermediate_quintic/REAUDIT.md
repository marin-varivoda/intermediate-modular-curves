# University presentation package: completed re-audit

All mathematical/source review, fresh original replays and fresh portable
replays are complete. The proof is supported by published theorems and
exact computations; this is not formal proof-assistant certification.
The chronological notes below retain intermediate findings, including
failures that were corrected and jobs that have since completed.

## Completion requirements

- [x] Inspect current worktree and preserve unrelated X1(41) research in
  a separate commit (806e367; no exact-gonality claim).
- [x] Re-run saved-result consistency checks: all 1388 pairs, 1011 strict,
  43 positive strict; six unit tests pass. This is not a fresh CAS replay.
- [x] Recompute the entire independent subgroup/signature census:
  `audit_runs/census/receipt.json`, all 1388 pairs agree.
- [x] Check the published inputs against the precise source statements,
  including base field, genus and minimum-density hypotheses; see
  `SOURCE_AUDIT.md` and the cited theorem/lemma numbers in the proof.
- [x] Audit rational descent, model identity and good reduction arguments.
  The mu-model convention and isomorphism are explicitly supported by
  Conrad--Edixhoven--Stein, proof of Lemma 6.1.6. Fresh exceptional model
  generation and the individual reduction checks are recorded below.
- [x] Audit every positive construction and replay its decisive checks:
  13 uniform low-genus cases, 14 canonical cases, 12 explicit witnesses,
  and four published pentagonal pairs.
- [x] Audit rank-zero, integral torsion and rational-class completeness.
  All 65 direct central values, both additional J1 inputs, the full
  level-40 integral lattice/Hecke sieve, and both level-48 transfer/class
  sieves have passed freshly. The proof and the row-coordinate dual-lattice
  construction have been reread; prime-primary exclusions are explicit.
- [x] Audit/replay Petri lifting and all positive-rank family exclusions.
  `audit_runs/special/receipt.json` now confirms all twelve exceptional
  negatives, including all five elliptic-family computations. The same
  formal lifting argument and the fixed-divisor deduction were reviewed.
- [x] Re-audit the upstream all-level X0 classification and its thirty
  newly resolved levels; identify this dependency explicitly in the text.
  The companion proof is included in the portable tree, with all 36
  freshly replayed certificates. The source theorem supplies the other
  levels and the N >= 192 boundary.
- [x] Write the TeX proof, positive list, endpoint lists, and exhaustive
  case-to-method/certificate appendix. The final theorem deduction now
  explicitly counts every class of assignments. Draft labels have been
  removed after completion of the original and portable replays.
- [x] Compile and inspect the PDFs, check bibliography and cross-references.
  Main proof: fourteen pages; upstream companion: ten pages. Both have
  no unresolved references, and the main build is warning-free. The
  positive, exceptional and negative tables were inspected; the twelve
  exceptional rows are kept together on one page.
- [x] Package the code and evidence with an unambiguous reproduction guide.
  All portable positive batches and all twelve portable negatives pass;
  `verify.py` checks the entire distribution without the working repository.
- [x] Clean only demonstrably unnecessary files, preserving accepted paths
  and all necessary proof evidence. The reduced bundle preserves required
  witness files and omits unreferenced experimental logs; X1 research remains
  separately committed outside this folder.

The final git commit and clean worktree are checked after sealing and
reported at handoff, rather than embedding a self-referential commit hash.

## Chronological findings (2026-09-06)

The saved ledger passes unchanged. In particular, it does not infer
positive-rank quintic finiteness merely from absence of quintic functions.
The rank-zero argument, exact-degree projection lemma, low-genus
constructions and formal lifting arguments have been read again.

Primary-source spot checks confirm that Kadets--Vogt Proposition 6.3 has
an arithmetic row covering genus >=9 for degree five, and that
Derickx--Orlic Corollary 4.10 supplies the stated optimal-parametrization
conclusion for N<=800 under its odd-analytic-rank hypothesis. This does
not yet verify every application or the entire bibliography.

The installed Magma V2.29-4 implementation was inspected at
`package/Geometry/ModAbVar/lser.m`, intrinsic `IsZeroAt(ModAbVarLSer, RngIntElt)`.
It tests the product of exact modular-symbol `LRatio` values of the simple
factors. The nonzero central-value flags in this workflow are therefore
not floating-point nonvanishing guesses. The theoretical algebraic-rank
implication remains a separately cited modular nonvanishing input.

The draft TeX compiled with Tectonic 0.17.0; the resulting PDF was opened
and a table page inspected. A repeated longtable label warning was fixed.
The final proof and bibliography are not complete, so this does not yet
discharge the final rendering/presentation gate.

Fresh positive computations now pass for all fourteen canonical low-genus
cases and all twelve new explicit degree-five constructions. Evidence:
`audit_runs/positive_batches/receipt.json` (14 + 11 cases) and
`audit_runs/positive64/receipt.json` (the remaining explicit construction).
These runs regenerate the modular-form models, not merely replay saved
negative search labels. The thirteen genus-at-most-two cases are covered
by the uniform very-ampleness argument; four positives use the published
pentagonality list. The positive source and descent audit remains necessary.

`replay_special.py` now re-executes all twelve exceptional negative
certificates in isolated copies, without overwriting the accepted evidence.
These replays use supplied canonical-model data and are explicitly labelled
as such. A case is complete only when its own new receipt exists; the
aggregate receipt is written only after all twelve return successfully.

All 36 upstream X0 certificate computations now pass afresh:
`audit_runs/x0/receipt.json`. This checks their execution, not by itself
every assertion in the upstream mathematical proof.

Every one of the 51 density-theorem assignments has passed a separate
comparison against the lower-degree classification in Derickx--Orlic,
Theorems 1.4--1.6: `audit_runs/density_hypotheses/receipt.json`.
`check_density_hypotheses.py` independently expands the eight relevant
quartic-positive subgroups. It checks full subgroup sets and genus
thresholds, so it does not infer minimum density five just from gonality.

The presentation now gives the flat-closure argument needed to justify
the good-reduction tests. Equal generic and special Hilbert polynomials
identify the special fiber of the flat closure with the displayed reduction;
reducedness, irreducibility, equality of normalization and arithmetic genus,
and a rational point then prove smooth geometric integrality. The code's
per-case execution of these tests remains part of the relevant certificate.

Nine exceptional replays have completed at this checkpoint: the three
Petri cases, level 43, level 40, both level-48 class sieves, and the
level-53 and level-61 families. Each has a new per-case receipt under
`audit_runs/special/`. The three level-65 family jobs are still running;
their invocation records identify isolated working directories and PIDs.
Do not restart them merely because an observation call times out.

The updated nine-page draft compiled with no unresolved cross-references.
The exceptional-case table was visually inspected on page eight and all
twelve rows fit. One harmless underfull bibliography line remains;
final typography and the complete bibliography are still outstanding.

All twelve exceptional canonical models have now been independently
regenerated from their full subgroups, with exactly identical Fourier
bases, Sturm-certified relations and exported equations:
`audit_runs/special_models/receipt.json`. Thus the special negative
certificates' saved model inputs now have a separate fresh-generation check.

The six small arithmetic inputs also pass afresh:
`audit_runs/arithmetic_inputs/receipt.json`. These give the elliptic-degree
bounds 12 and 8 at 37 and 57, exclude positive-rank elliptic factors at
73, 109 and 125, and prove rank zero of J1(35) and J1(41).

The TeX appendix now lists all 154 direct negative assignments and all
seven non-X0 forgetting maps. The CSV includes the previously omitted
projection target and complete proof metadata (without duplicating long
cusp-width arrays). The table generator checks the seven subgroup-image
conditions and the targets' genus and negative status.

The upstream proof has now been read through all three routes, including
the fixed-divisor argument in the quotient route, the level-98 Picard-class
refinement, and the repeated-isotypic direction argument. Particular code
checks read include exhaustive multiset enumeration, whole-coset enumeration,
the common differential basis, and the trace-rank/immersion assertions even
at primes dividing the quotient degree. This is additional mathematical
review, distinct from the already completed 36-run replay.

The reduced `reproduction/` bundle now passes its own saved-evidence audit
and reproduces both inventories byte-for-byte (904 machinery files).
A fresh portable level-40 test caught a missing original-location point
witness, although its copied version was present in the hash certificate.
The packaging rule was corrected to preserve all Magma input/witness files.
The first incomplete packaging attempt was moved to
`/tmp/quintic-bundle-first.T8r91o/reproduction`, not deleted.

`test_portable_special.py` is now replaying all twelve exceptional negatives
using only copies of the corrected portable tree. Its outputs go under
`audit_runs/portable_special/`. This separate test must finish before the
fresh-reproduction portability gate is considered satisfied.

Both genus-eleven level-65 family replays have completed in the original
isolated audit. The genus-nine p=7 replay remains live. The current PDF has
13 pages and no unresolved references; its negative appendix was visually
inspected. Remaining typography warnings are underfull bibliography lines.

The standalone `verify.py` checks the portable file hashes, every CSV
assignment, the full generated subgroups and method codes in both main
TeX tables, and all seven projection targets. It reruns the saved ledger
in a temporary copy and requires every aggregate replay receipt. Its
current development-mode result is correctly INCOMPLETE because the
original and portable special-family aggregate receipts are still pending.

The original twelve-case special replay has now completed in full. The
genus-nine level-65 computation took 1665 seconds. The separate portable
replay has eleven completed cases and its final genus-nine case remains
live; no restart has been requested. `test_portable_positive.py` now also
tests all positive construction batches from isolated portable-tree copies.

The main fourteen-page proof and the included ten-page `x0_proof.pdf`
compile without unresolved references. The main proof's bibliography now
uses ragged-right typesetting and the compilation is warning-free.

All portable positive batches now pass:
`audit_runs/portable_positive/receipt.json`. Eleven of the twelve portable
negative cases also pass. Only the portable genus-nine level-65 computation
is still running. The complete original mathematical computation has
already passed, so the remaining test concerns fresh reproducibility
from the reduced distribution tree. `verify.py --development` correctly
reports only the missing `portable_special` aggregate receipt.

The final sealing utility is in place. A test invocation returned
INCOMPLETE for the missing portable-special aggregate and wrote no seal.
Both the verifier and sealing utility reject optimized Python execution;
the rejection was tested, preventing disabled assertions from producing
an apparent successful verification.

Final result: `audit_runs/portable_special/receipt.json` now reports all
twelve portable negatives passed. The final genus-nine case took 1390
seconds. `verify.py --development` passes with no pending replay records.
The low-genus proof was simplified to the Riemann--Roch identity
h0(5P)-h0(4P)=1 for genus at most two, directly giving pole divisor 5P.

Fresh audit outputs belong in `audit_runs/`, not on top of frozen
certificates. A successful hash check is never labelled a mathematical
recomputation.
