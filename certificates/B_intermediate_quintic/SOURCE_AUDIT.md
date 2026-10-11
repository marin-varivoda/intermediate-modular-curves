# Published inputs and their precise role

This records source checks, not independent reproofs of published theorems.
New computations are recorded separately in `audit_runs/`.

## Gonality and lower-degree density

[Orlic, Tetragonal intermediate modular curves, v1](https://arxiv.org/html/2407.14512v1):
Theorems 1.3--1.5 match all 21 tetragonal and four pentagonal subgroup
entries in `published_gonality.py`. The comparison uses full subgroups;
different generator lists can describe the same curve. The preceding
hyperelliptic/trigonal classification has no strict genus-at-least-five
exception. Theorem 3.16 gives the index bound used in the spectral cases.

[Derickx--Orlic, quartic points, v1](https://arxiv.org/html/2504.15937v1):
Theorems 1.4--1.6 supply the degree-two, -three and -four exclusions.
All 51 density-theorem applications were compared against the relevant
subgroups by `check_density_hypotheses.py`; none is quartic-positive.
Corollary 4.10 requires odd analytic rank and gives the claimed optimal
composition when N <= 800. Multiplicity one and full conductor are also
required before concluding that every elliptic map factors through it.
The proof of Corollary 4.12 supplies these conductor/rank inputs for the
listed levels. The separate calculations at 37, 57, 73, 109 and 125 were
re-executed in `audit_runs/arithmetic_inputs/`.

[Kadets--Vogt, v2](https://arxiv.org/html/2208.01067v2):
Proposition 6.3's **arithmetic** row for minimum density five allows covers,
Debarre--Fahlaoui normalizations, and genera five through eight. The
genus-nine/ten deduction therefore must include the DF alternative.
The stated adjunction computation forces an elliptic map of degree six
or seven in that alternative. The higher-genus bound applies from genus
twelve, after the lower-degree finiteness checks, not from gonality alone.

## Rank zero and integral torsion

[Derickx--Sutherland](https://math.mit.edu/~drew/proc13605.pdf), Section 4,
explicitly uses exact modular-symbol L-ratios and Kato's Corollary 14.3
to deduce rank zero for quotients of J1. This supplies the nontrivial-
nebentypus implication, rather than citing only the J0 version.
Theorem 4.1 gives rank zero of J1(N) for N <= 36. The installed Magma
`IsZeroAt` overload was checked separately; it does not use a floating-
point nonvanishing guess. Theorem 1.1 and Corollary 2.4 also justify the
X1 endpoint list and its exact degree-five maps.

[Derickx--Etropolski--van Hoeij--Morrow--Zureick-Brown, v2](https://arxiv.org/html/2007.13929v2),
Theorem 4.13 applies at N=48: rational torsion is the rational cuspidal
group. The excluded level 54 is irrelevant. The level-48 proof computes
the embedding of that group afresh, not just its order. The level-40
Hecke argument uses the method in Section 4.3, with residue-primary
constraints omitted as documented in `HECKE_TORSION40.md`.

## Bielliptic and endpoint inputs

[Jeon--Kim--Schweizer](https://arxiv.org/html/1709.00510), Theorem 0.2
and Table 6, identify the genus-seven subgroup at 35 and genus-nine
subgroup at 55 used here. Geometric biellipticity suffices for the
Castelnuovo--Severi exclusion; rationality of the involution is not needed.

[Derickx--Hwang--Jeon--Orlic, v2](https://arxiv.org/html/2503.08975v2),
Theorem 1.10 gives precisely the displayed positive X0 list and excludes
N >= 192. Its thirty outstanding levels are the separate upstream proof
dependency, not claimed as consequences of that published theorem.
All 36 computations in the upstream package have been replayed.

[Najman--Varivoda, v4](https://arxiv.org/html/2602.03513v4), Proposition 5.5,
requires point/divisor lifting as well as injective Jacobian reduction.
The upstream proof applies it directly at 96 and 100, but expressly
does not apply it unchanged at 98: two residue points fail to lift.
The degeneracy-map Picard-class argument is needed there.

[Najman--Orlic, Gonality of X0(N), v4](https://arxiv.org/html/2207.11650),
Theorems 1.2 and 1.4, supply the upstream rational quartic pencils at
74, 77, 85 and 88 and rational gonality six at 82. These precise uses
were checked against the theorem lists; gonality four is not treated as
an obstruction to a degree-five function.

## Rational model convention and review scope

[Conrad--Edixhoven--Stein](https://virtualmath1.stanford.edu/~conrad/papers/j1p.pdf),
proof of Lemma 6.1.6, explicitly gives the mu-marked model, its rational
Tate cusp and standard analytic q-expansion, and its isomorphism with the
point-marked model after inverting N. This supports the rational convention;
the descent to each Delta quotient follows from inverse diamond actions.

The rational-model duality, integral lattice constructions, formal lifting
and fixed-divisor deductions are mathematical arguments of this package,
not claims imported from a database. Their detailed notes and executable
checks are included with the distributable proof. The completed review and
fresh original and portable replay records are indexed in `REAUDIT.md`.
This is a mathematical and computational review, not formal verification
in a proof assistant.
