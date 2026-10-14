# Intermediate modular curves: checked classification table

**Status: all listed cases classified.**
There are 1,388 subgroup-defined curves through level 191, including the X0 and X1 endpoints. 0 entries remain unresolved.
Levels above 191 are handled by projection to X0(N) (paper, Section 7.1).
Rows distinguish subgroups, not Q-isomorphism classes of curves.

## Proved positive strict intermediate curves

All 43 curves below have a function of exactly degree five over Q,
hence infinitely many closed points of exactly degree five.
Here Δ=⟨−1,a,…⟩ denotes the subgroup generated modulo N.

| N | Δ generators | Genus | Existence proof |
|---:|---|---:|---|
| 13 | ⟨-1, 3⟩ | 0 | Riemann–Roch, genus ≤2 |
| 13 | ⟨-1, 5⟩ | 0 | Riemann–Roch, genus ≤2 |
| 15 | ⟨-1, 4⟩ | 1 | Riemann–Roch, genus ≤2 |
| 16 | ⟨-1, 7⟩ | 0 | Riemann–Roch, genus ≤2 |
| 17 | ⟨-1, 2⟩ | 1 | Riemann–Roch, genus ≤2 |
| 17 | ⟨-1, 4⟩ | 1 | Riemann–Roch, genus ≤2 |
| 19 | ⟨-1, 7⟩ | 1 | Riemann–Roch, genus ≤2 |
| 20 | ⟨-1, 9⟩ | 1 | Riemann–Roch, genus ≤2 |
| 21 | ⟨-1, 4⟩ | 1 | Riemann–Roch, genus ≤2 |
| 21 | ⟨-1, 8⟩ | 3 | Exact canonical low-genus check |
| 24 | ⟨-1, 5⟩ | 3 | Exact canonical low-genus check |
| 24 | ⟨-1, 7⟩ | 3 | Exact canonical low-genus check |
| 24 | ⟨-1, 11⟩ | 1 | Riemann–Roch, genus ≤2 |
| 25 | ⟨-1, 4⟩ | 0 | Riemann–Roch, genus ≤2 |
| 25 | ⟨-1, 7⟩ | 4 | Exact canonical low-genus check |
| 26 | ⟨-1, 3⟩ | 4 | Exact canonical low-genus check |
| 26 | ⟨-1, 5⟩ | 4 | Exact canonical low-genus check |
| 27 | ⟨-1, 8⟩ | 1 | Riemann–Roch, genus ≤2 |
| 28 | ⟨-1, 3⟩ | 4 | Exact canonical low-genus check |
| 28 | ⟨-1, 13⟩ | 4 | Exact canonical low-genus check |
| 29 | ⟨-1, 4⟩ | 4 | Exact canonical low-genus check |
| 30 | ⟨-1, 11⟩ | 5 | Verified degree-five function |
| 31 | ⟨-1, 2⟩ | 6 | Published gonality-five theorem |
| 31 | ⟨-1, 5⟩ | 6 | Published gonality-five theorem |
| 32 | ⟨-1, 7⟩ | 1 | Riemann–Roch, genus ≤2 |
| 32 | ⟨-1, 15⟩ | 5 | Verified degree-five function |
| 33 | ⟨-1, 2⟩ | 5 | Verified degree-five function |
| 34 | ⟨-1, 9⟩ | 5 | Verified degree-five function |
| 35 | ⟨-1, 4⟩ | 5 | Verified degree-five function |
| 36 | ⟨-1, 11⟩ | 3 | Exact canonical low-genus check |
| 37 | ⟨-1, 3⟩ | 4 | Exact canonical low-genus check |
| 37 | ⟨-1, 8⟩ | 4 | Exact canonical low-genus check |
| 39 | ⟨-1, 4⟩ | 5 | Verified degree-five function |
| 40 | ⟨-1, 7⟩ | 7 | Verified degree-five function |
| 40 | ⟨-1, 9, 11⟩ | 5 | Verified degree-five function |
| 41 | ⟨-1, 2⟩ | 5 | Verified degree-five function |
| 44 | ⟨-1, 5⟩ | 8 | Published gonality-five theorem |
| 45 | ⟨-1, 4⟩ | 5 | Verified degree-five function |
| 48 | ⟨-1, 11⟩ | 5 | Verified degree-five function |
| 49 | ⟨-1, 6⟩ | 3 | Exact canonical low-genus check |
| 50 | ⟨-1, 9⟩ | 4 | Exact canonical low-genus check |
| 64 | ⟨-1, 7⟩ | 5 | Verified degree-five function |
| 125 | ⟨-1, 4⟩ | 16 | Published gonality-five theorem |

## Remaining cases

None.

## Four groups of arguments cover the strict curves

| Argument | Number of curves |
|---|---:|
| Projection and gonality filters | 829 |
| Rank-zero Jacobian arguments | 82 |
| Positive-rank density and elliptic-family arguments | 57 |
| Degree-five function constructions | 43 |

The arguments are in Section 7 of the paper; `../../README.md` maps each class to its
certificates. The X0 and X1 endpoints are inputs (Theorem A of the paper, DHJO Theorem 1.10,
Derickx-Sutherland). The machine-readable inventory records the proof source of every row.

Regenerate after running `build_inventory.py` and `build_complete_inventory.py`:
`python3 write_classification_report.py`.
