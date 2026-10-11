# Two rank-zero bielliptic exclusions

The remaining curves

* level 35, Delta={±1,±6,±8,±13}, genus 7;
* level 55, Delta={±1,±4,±6,±9,±14,±16,±19,±21,±24,±26}, genus 9

are geometrically bielliptic by Jeon--Kim--Schweizer, Theorem 0.2 and
Table 6 (their Delta_3(35) and Delta_4(55)):
[Bielliptic intermediate modular curves](https://arxiv.org/pdf/1709.00510).
These are the only genus-greater-than-six entries in their complete
bielliptic list. This is a published input, not an import from home code.

Here is the elementary consequence for **exactly** degree five. If a curve
C has a degree-two map to an elliptic curve and a degree-five map to P1,
the two maps generate its function field: the degree over their compositum
divides both 2 and 5, so is one. Castelnuovo--Severi then gives

    g(C) <= 2*1 + 5*0 + (2-1)*(5-1) = 6.

Equivalently, the image in E x P1 has arithmetic genus six by adjunction,
and its normalization cannot have higher genus. Thus neither curve above
has a degree-five function, even over Qbar. Their degree-four functions
do not contradict this obstruction. No rationality assertion about the
bielliptic involution is needed.

The fresh intermediate central-value computations prove rank zero of both
Jacobians. The full subgroup and dimensions 7 and 9 are checked in
`intermediate_central/d98511aa0f90f7c4.log` and
`intermediate_central/1e5199b136fae728.log` respectively.
Consequently Pic^5(Q) is finite. If an irreducible rational quintic divisor
D had h0(D)>1, a nonconstant element of L(D) would have poles exactly D
and provide the excluded function. Hence each rational divisor class
contains at most one irreducible quintic divisor, proving finiteness.

In particular, a negative bounded function search is not used anywhere
in this deduction.
