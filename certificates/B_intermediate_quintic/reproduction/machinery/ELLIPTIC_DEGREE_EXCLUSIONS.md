# A uniform higher-genus exclusion

This is a deduction from published theorems, not a certificate imported from
the home-directory project. The source is
[Derickx–Orlić, *Intermediate modular curves with infinitely many quartic
points*, v1](https://arxiv.org/html/2504.15937v1).

Consider a strict intermediate curve of genus at least 12 at one of

    37, 43, 53, 55, 57, 58, 61, 65, 67, 73, 91, 121.

1. Theorems 1.4, 1.5 and 1.6 exclude infinitely many points of each degree
   1, 2, 3 and 4. For degree 1 use genus > 1. In Theorem 1.6's table the
   only strict curve of genus at least 12 is at level 101, outside our list;
   the levels covered wholesale there have no strict curves of genus 12.
2. The published gonality classification excludes degree-five functions
   for these curves (the implementation checks `at_least_six` separately).
3. The proof of Corollary 4.12 states that, at all the selected levels,
   every positive-rank elliptic isogeny factor has conductor N and analytic
   rank one. Such a factor occurs once. Corollary 4.10 says the composite
   of X_Delta -> X_0 with the strong Weil parametrization X_0 -> E remains
   a strong Weil parametrization. Its degree is t*d, where
   t = [(Z/NZ)^*:Delta] >= 2 and d is the modular degree at level N.
4. Here genus(X_0(N)) > 1, so d >= 2. Every nonconstant map to an elliptic
   curve in that isogeny class factors through this optimal parametrization
   followed by an isogeny (up to translation). Its degree is therefore a
   positive integer multiple of t*d. This cannot equal the prime 5:
   neither t nor d is 1. This argument does NOT infer nonexistence merely
   from the absence of degree-four maps, nor does it require a numerical
   lower bound d >= 5. All positive-rank isogeny classes are covered.
5. If quintic points were infinite, the minimum density degree would be
   exactly 5 by step 1. Corollary 2.5 would then give a degree-five map to
   P^1 or a positive-rank elliptic curve, contradicting steps 2–4.

The genus threshold and the minimum-density hypothesis are essential.
This argument does not settle the remaining genus-eight, genus-nine or
genus-eleven curves, or curves with infinitely many quartic points.

We use the stated published results, including their elliptic-factor and
Shimura-kernel inputs. We do not claim to have recomputed these inputs here.

## Levels 109 and 125: no positive-rank elliptic factors

The same density reduction works here, with a simpler elliptic obstruction.
Fresh `elliptic_factors.m` runs decompose J_0(109) into simple factors of
dimensions 1, 3, 4, and J_0(125) into simple factors of dimensions 2, 2, 4.
The sole elliptic factor at 109 has certified rank bounds [0,0]; there is
no elliptic factor at 125. Thus neither admits a positive-rank elliptic
quotient. The introduction to Section 4 of the cited paper explains why
elliptic factors over Q occur with identical multiplicity in J_Delta(N)
and J_0(N): an elliptic newform has trivial nebentypus. This excludes such
quotients for every subgroup at these levels.

For strict curves of genus at least 12, the preceding minimum-density
argument and the separately checked gonality bound now prove finiteness.
The positive pentagonal curve at level 125 has genus 16, but does not
satisfy the required gonality-at-least-six hypothesis and is not excluded.
The ledger requires the complete new factor-census success log,
including the rank-zero assertion, before applying this rule.
