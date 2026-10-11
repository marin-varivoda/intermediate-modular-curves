# Theorem D: the gonality of $X_1(N)$ for $41\le N\le 50$

| $N$ | 41 | 42 | 43 | 44 | 45 | 46 | 47 | 48 | 49 | 50 |
|---|---|---|---|---|---|---|---|---|---|---|
| $\mathrm{gon}_{\mathbb Q} X_1(N)$ | 22 | 12 | 24 | 15 | 18 | 19 | 29 | 16 | 21 | 15 |

**Upper bounds.** Derickx and van Hoeij: the coordinate $x$ of the Sutherland–van Hoeij model is a modular unit
whose degree is the number in the table. Nothing is computed for the upper bounds here.

**Lower bounds.** At a prime $p$ of good reduction, $\mathrm{gon}_{\mathbb Q}X_1(N)\ge\mathrm{gon}_{\mathbb F_p}X_1(N)_{\mathbb F_p}$.
So it suffices to show that the reduction has no function of degree at most $d=\text{upper bound}-1$ over
$\mathbb F_p$. The prime and $d$ for each level are in `levels.csv`. Level 48 is done differently, through a
double cover (see below).

## Method

Write $X$ for the reduction, $g$ for its genus and $q=p$. The test follows Derickx and Terao's
`CAHasFunctionOfDegreeAtMost`, and is split into two phases.

**Phase 1 (Magma, CurveArith unchanged).** `phase1/phase1.m` calls CurveArith's own
`PrecomputePowerseriesExpansions` with exactly the places and precisions that `CAHasFunctionOfDegreeAtMost`
uses. Those places are all places of degree $\le d-n_1$, where $n_1=\lceil\#X(\mathbb F_q)/(q+1)\rceil$. The output
is the power series expansions of a basis of holomorphic differentials at each of these places. The script then
writes the expansions to a text file instead of passing them to CurveArith's search. Only this output step is new.

**Phase 2 (C++).** A function $f$ of degree $e\le d$ has a fibre $f^*(a)$ for some $a\in\mathbb P^1(\mathbb F_q)$.
CurveArith enumerates all effective divisors of degree $e$ that could be such a fibre. `phase2/` enumerates the
smaller family $F_b(d)$ of the paper (§3.3), the divisors $H=bS+E+Q$. For each $H$ it computes the kernel of the
matrix $M_H$ of expansions. By Riemann–Roch, $\ell(D)=\deg D+1-\mathrm{rank}\,M_D$ for every
$D\le H$, so the kernel gives the least degree of a function in $L(H)$ directly. All arithmetic is exact
(GMP, or $\mathbb F_p$ directly). The output `phase2.json` reports:

- `answer`: whether a function of degree $\le d$ was found;
- `complete`: whether every divisor of the family was tested;
- `covers` and `expected_covers`: the number of divisors tested, and an independent count of the family;
- `magma_checks`: the number of Riemann–Roch dimensions computed in Phase 1 with Magma's own `Dimension`.
  Phase 2 recomputes each of them from the rank formula and stops if any disagrees.

**Why the two phases agree with CurveArith.** Phase 1 is CurveArith's code. Phase 2 is a different but complete
search (paper, Proposition 3.3). `validation/validate.py` reruns both phases on $X_1(26)$ at $p=3,5,7$ and $X_1(29)$ at
$p=2,3$, at $d=\mathrm{gon}_{\mathbb F_p}-1$ and $d=\mathrm{gon}_{\mathbb F_p}$. It checks that the answers are
"no" and "yes", against CurveArith's unmodified `CAGonality`. The results are in `validation/validate*.log`.

**Models.** `models/X1_N.txt` are the Sutherland–van Hoeij plane models. `model_checks.m` checks, for each level
and prime used, that the reduction mod $p$ has the same degree in $y$, is irreducible with exact constant field
$\mathbb F_p$, and has genus $g(X_1(N))$. By §2.2 of the paper, this identifies its function field with that of
$X_1(N)_{\mathbb F_p}$. The output is in `model_checks.log`.

## Running Phase 1 in parallel

Most of the time is spent in Phase 1, in computing expansions at places of large degree. `phase1/run_phase1.py`
splits the places between several Magma processes and merges their output.

- **Splitting by a key, not by position.** Magma does not list the places in the same order in every process.
  So a place is assigned to a process by a key computed from the place itself: the irreducible polynomial
  below it, hashed. When the outputs are merged, the script checks two things. Every process must have found the
  same curve, the same place counts and the same basis of differentials. For every degree, the places from all
  processes must add up to the total count.
- **Memory.** Every process enumerates all the places before computing its share of the expansions, so adding
  processes does not reduce memory per process. `MEMGB` sets a hard Magma memory limit per process, and
  `levels.csv` records the value used for each level.
- **Frozen script.** Each run copies `phase1.m` into its run folder and uses that copy. Magma reads a script
  incrementally while running it, so editing the original cannot affect a running job.
- **Rerunning one process.** `MERGE_ONLY=1` skips the Magma step and only merges existing outputs. This is useful
  after rerunning one process by hand.

## Running

Requirements: Magma (tested with V2.29-4), a C++20 compiler and GMP. CurveArith is the pinned submodule in
`third_party/`.

```sh
./run.sh 45                 # Phase 1 with the processes and memory in levels.csv, then Phase 2
THREADS=16 ./run.sh 47      # Phase 2 threads (default 8)
cd validation && python3 validate.py
magma -b model_checks.m
```

Each run writes to `runs/x1_N/`. The repository keeps the Magma logs `shard_*.log` and the Phase 2 result
`phase2.json`. It does not keep the Phase 1 output `curve.ffjets` (up to several GB), which `run.sh` recreates.
`runs/SUMMARY.csv` collects the numbers from the logs:

| $N$ | $p$ | $g$ | $d$ | places | Phase 1 (h) | memory limit (GB) | Phase 2 (min) | divisors tested |
|---|---|---|---|---|---|---|---|---|
| 41 | 2 | 51 | 21 | 2669 | 2.9 | — | 0.2 | 2 643 150 |
| 42 | 5 | 25 | 11 | 277 397 | 10.8 | 40 | 2.6 | 3 860 784 |
| 43 | 2 | 57 | 23 | 8515 | 6.1 | 10 | 0.8 | 17 156 720 |
| 44 | 3 | 36 | 14 | 9518 | 0.8 | — | 0.4 | 3 133 892 |
| 45 | 2 | 41 | 17 | 1608 | 1.4 | — | < 0.1 | 265 608 |
| 46 | 3 | 45 | 18 | 69 995 | 14.7 | 75 | 15.8 | 374 417 725 |
| 47 | 2 | 70 | 28 | 110 354 | 30.2 | 150 | 59.4 | 651 609 964 |
| 49 | 2 | 69 | 20 | 1497 | 3.4 | — | 0.2 | 2 167 431 |
| 50 | 3 | 48 | 14 | 3369 | 2.7 | — | < 0.1 | 41 835 |

"Phase 1 (h)" is the wall-clock time of the slowest process. "Memory limit" is the per-process limit the
completed run used; levels marked — ran without a limit (on a machine with 376 GB).

In every row, Phase 2 tested all `expected_covers` divisors and found no function of degree $\le d$.

A note on two logs. In `runs/x1_46/shard_1.log`, the run ends with `PHASE1_DONE` after 40 175 s. The lines
after that are left over from a duplicate start of the same process. That duplicate was launched from the wrong
directory, failed to load CurveArith, and wrote into the same file; it did not affect the output. Process 0 of
$X_1(47)$ was restarted once with a larger memory limit, and its log is from the completed run.

## Level 48: the double cover

At $N=48$ the place counts over small fields are too large for Phase 1. Instead, `double_cover_48/` works on the
quotient $Y=X_1(48)/\langle 23\rangle$, which has genus 13 (paper, §5.1). A function of degree $\le 15$ on
$X_1(48)_{\mathbb F_7}$ has a norm to $Y$ of degree $\le 15$, and the norm bound limits the possible divisors of
that norm. `dc_certificate.m` enumerates all 1328 effective divisors $E$ allowed by this bound and all candidate
functions. Of the 3 709 104 candidate functions, all but 18 are discarded by the norm bound; the remaining 18 are
checked directly, and none has degree $\le 15$.

- `check_Y_reduction.m` checks good reduction of $Y$ at 7.
- `run_24_*.m` and `run_26_*.m` are tests of the method on levels 24 and 26, where the answer is known.
- `runs48/` holds the certificate itself, split into parts by a key of $E$ (as in Phase 1). Parts 0, 3, 4 and 6
  of 8 are in `shard_*.log`. Parts 1, 2, 5 and 7 exceeded their 16 GB limit (part 0 ran at 24 GB), so each was split in two and
  redone as parts $\lbrace 1,9\rbrace$, $\lbrace 2,10\rbrace$, $\lbrace 5,13\rbrace$ and $\lbrace 7,15\rbrace$ of 16, at 30 GB each, in `redo16_*.log`.
  Every certified log ends with `CERTIFIED gon(X1(48) over F_7) > 15`. The counts `effective_E_this_shard` of
  the twelve logs add up to 1328.
- `runs48/RESULT.json` summarises the run.
