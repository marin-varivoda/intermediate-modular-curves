# MD Sage: enumeration and canonical models, strict X_Δ(N), N ≤ 50

Test of whether published code (Derickx's MD Sage) is good enough for enumeration and models.
**Result: yes.**

MD Sage commit: `602242974e6edc01e7466c46949d40ff589a6fbf` (v0.1.0-8-g6022429, github.com/koffie/mdsage).
Software: SageMath 10.7, Magma V2.29-4.

```sh
python run.py --mdsage /path/to/mdsage --out results --workers 8     # about 20 s
python3 hilbert_check.py results/curves.json results/hilbert_check.m
magma -b results/hilbert_check.m                                     # under 1 s
```

## Findings

- **Enumeration.** `intermediate_modular_groups(N)` gives **76 strict curves** for N ≤ 50. They
  agree exactly with the old census, both as full subgroup Δ and in genus.
- **Models.** For all **49** curves of genus ≥ 5, `vanishing_quadratic_forms(G,
  minimize_strategy="LLL")` returns (g−2)(g−3)/2 quadrics. No curve of genus ≥ 5 in this range is
  trigonal over Q. With LLL, every coefficient has at most 2 digits. Without it, coefficients reach
  about 145 digits.
- **Independent checks, all passed:**
  1. every quadric vanishes on the integral cusp-form basis beyond the weight-4 Sturm bound;
  2. in Magma, each ideal has Hilbert polynomial (2g−2)t + 1 − g.

  Together with the containment in check 1, check 2 identifies the scheme with the canonical curve.
  - Negative control, on the genus-22 curve: keeping half the quadrics changes the Hilbert
    polynomial.
  - Dropping one quadric does not change it. This is expected: the curve is already cut out by
    fewer quadrics. The quadric count and check 1 cover completeness in degree 2.
- **The 27 curves without a quadric model:**
  - **13 of genus ≤ 2.** Genus 0 and 1 at levels 13–32. No model is needed: see the low-genus lemma
    in PLAN.md.
  - **1 hyperelliptic over Q:** 21.96.3.a.1 (Ishii–Momose).
  - **13 of genus 3 or 4:**
    - for genus 3, `subhyperelliptic_primes` shows the curve is not hyperelliptic, and a rational
      cusp then gives gonality 3 with no model;
    - for genus 4, MD Sage still returns the unique canonical quadric, and whether it has a
      Q-rational ruling decides Q-gonality 3.

    So no curve at N ≤ 50 needs a model from any other source.
    [To confirm case by case, including 49.168.3.b.1 and 50.180.4.a.2.]

Output: `results/curves.json` (subgroup, index, genus, cusps, special primes, equations),
`results/hilbert_check.log`.
