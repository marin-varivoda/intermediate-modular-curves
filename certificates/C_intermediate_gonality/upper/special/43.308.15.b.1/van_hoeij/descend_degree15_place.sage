#!/usr/bin/env sage
"""Descend van Hoeij's unique degree-15 place on X_1(43).

The input point is the N=43, degv=15, degj=5 record in LowDegreePlaces.
We evaluate the exact modular units F_2,...,F_22 in Tate normal form, then
evaluate the two F-monomials defining the extended X_Delta model.
"""

from sage.all import *
import json
from pathlib import Path


ROOT = Path(__file__).resolve().parents[2]
METADATA_PATH = ROOT / "extended_models/43.308.15.b.1/model_metadata.json"
load(str(ROOT / "extended_model_generation/tate_x1_map.sage"))

Rt.<t> = PolynomialRing(QQ)
place_polynomial = (
    t^15 - 9*t^14 + 21*t^13 + 14*t^12 - 85*t^11 + 28*t^10
    + 99*t^9 - 59*t^8 - 33*t^7 + 33*t^6 - 12*t^5 - 6*t^4
    + 13*t^3 + t^2 - 4*t - 1
)
K.<alpha> = NumberField(place_polynomial)

van_hoeij_y_numerator = (
    882583*alpha^14 - 8361953*alpha^13 + 22219204*alpha^12
    + 4006085*alpha^11 - 80258022*alpha^10 + 55548319*alpha^9
    + 75374686*alpha^8 - 83025032*alpha^7 - 4631869*alpha^6
    + 35722009*alpha^5 - 24925492*alpha^4 + 2664228*alpha^3
    + 12279174*alpha^2 - 4252675*alpha - 2692776
)
x0 = alpha
y0 = -van_hoeij_y_numerator / 356723

r = (x0^2*y0 - x0*y0 + y0 - 1)/(x0^2*y0 - x0)
s = (x0*y0 - y0 + 1)/(x0*y0)
B = r*s*(r - 1)
C = s*(r - 1)
discriminant = B^3 * (
    16*B^2 + (1 - 20*C - 8*C^2)*B + C*(C - 1)^3
)
assert discriminant != 0

# Values P_k = psi_k(0,0) of the division polynomials in Tate normal form.
P = {
    1: K(1),
    2: -B,
    3: -B^3,
    4: C*B^5,
}
for k in range(5, 23):
    if k % 2:
        ell = (k - 1)//2
        P[k] = P[ell + 2]*P[ell]^3 - P[ell - 1]*P[ell + 1]^3
    else:
        ell = k//2
        P[k] = (
            P[ell]/P[2]
            * (P[ell + 2]*P[ell - 1]^2 - P[ell - 2]*P[ell + 1]^2)
        )

# Exact modular-unit normalization from van Hoeij--Smith, equation (36):
# P_k = F_3^floor(k^2/3) * product_{3<d|k} F_d.
F = {
    2: B^4/discriminant,
    3: -B,
}
for k in range(4, 23):
    proper_factor = prod(
        F[d] for d in divisors(k) if 3 < d < k
    )
    F[k] = P[k] / (F[3]^(k^2//3) * proper_factor)
    assert F[k] != 0

with METADATA_PATH.open() as stream:
    metadata = json.load(stream)

F_indices = metadata["modular_units"]["F_index_order"]
X_exponents = metadata["modular_units"]["X"]["F_exponents"]
Y_exponents = metadata["modular_units"]["Y"]["F_exponents"]

def evaluate_monomial(exponents):
    return prod(F[k]^e for k, e in zip(F_indices, exponents))

X_value = evaluate_monomial(X_exponents)
Y_value = evaluate_monomial(Y_exponents)

# Check the reusable function-field realization of X_1(N) -> X_Delta(N)
# against the independently expanded calculation above.
map_X_value, map_Y_value = evaluate_extended_coordinates(metadata, x0, y0)
assert map_X_value == X_value
assert map_Y_value == Y_value
print("REUSABLE_X1_TO_XDELTA_MAP_VERIFIED=true")

RXY.<X,Y> = PolynomialRing(QQ, 2)
model = RXY(metadata["plane_relation"])
assert model(X_value, Y_value) == 0

j_value = EllipticCurve(
    K, [1-C, -B, -B, 0, 0]
).j_invariant()

for name, value in [("X", X_value), ("Y", Y_value), ("j", j_value)]:
    minimal = value.minpoly()
    print("%s_DEGREE=%s" % (name, minimal.degree()))
    print("%s_MINPOLY=%s" % (name, minimal))

assert X_value.minpoly().degree() == 5
assert Y_value.minpoly().degree() == 5
assert j_value.minpoly().degree() == 5

# Express Y and j in the degree-5 field Q(X), both as a useful certificate
# and for reduction/matching against the finite-field places.
KX.<xbar> = NumberField(X_value.minpoly())
roots_in_K = X_value.minpoly().roots(K)
assert any(root == X_value for root, multiplicity in roots_in_K)
embed_KX_to_K = KX.hom([X_value], K)

def preimage_in_KX(value):
    # Solve for coefficients in 1,X,...,X^4 over Q inside the degree-15 field.
    basis_images = [X_value^i for i in range(5)]
    matrix_columns = matrix(QQ, [
        list(element) for element in basis_images
    ]).transpose()
    target = vector(QQ, list(value))
    solution = matrix_columns.solve_right(target)
    candidate = sum(solution[i]*xbar^i for i in range(5))
    assert embed_KX_to_K(candidate) == value
    return candidate

Y_in_KX = preimage_in_KX(Y_value)
j_in_KX = preimage_in_KX(j_value)
print("Y_AS_POLYNOMIAL_IN_X=%s" % Y_in_KX)
print("J_AS_POLYNOMIAL_IN_X=%s" % j_in_KX)

for prime in [2, 3, 5]:
    print(
        "X_MINPOLY_FACTOR_DEGREES_MOD_%s=%s"
        % (
            prime,
            sorted(
                factor.degree()
                for factor, multiplicity
                in X_value.minpoly().change_ring(GF(prime)).factor()
                for _ in range(multiplicity)
            ),
        )
    )

print("MODEL_RELATION_VERIFIED=true")
print("DEGREE_15_PLACE_DESCENDS_TO_DEGREE_5=true")

# Also evaluate the coordinates of the smaller bidegree-(10,10) model used
# by CAGonality.  Keeping these here gives an exact bridge between the
# cusp-aware model and the cheaper normalization without recomputing the
# degree-15 point.
small_X_value = (
    F[9] * F[11]^2 * F[20] * F[22]
    / (F[7] * F[8] * F[16] * F[17] * F[21])
)
small_Y_value = (
    F[3]^2 * F[6] * F[7]^5 * F[18] * F[21]^5
    / (F[4] * F[5] * F[10] * F[11]^5 * F[20] * F[22]^4)
)
small_model_text = (ROOT / "gonality_43_308_15_b_1/model.m").read_text()
small_relation = RXY(
    small_model_text.split("model :=", 1)[1].rsplit(";", 1)[0].strip()
)
assert small_relation(small_X_value, small_Y_value) == 0
small_X_in_KX = preimage_in_KX(small_X_value)
small_Y_in_KX = preimage_in_KX(small_Y_value)
print("SMALL_X_AS_POLYNOMIAL_IN_EXTENDED_X=%s" % small_X_in_KX)
print("SMALL_Y_AS_POLYNOMIAL_IN_EXTENDED_X=%s" % small_Y_in_KX)
K_small_X.<u> = NumberField(small_X_value.minpoly())
embed_small_X = K_small_X.hom([small_X_value], K)
small_basis_matrix = matrix(QQ, [
    list(small_X_value^i) for i in range(5)
]).transpose()
small_Y_coefficients = small_basis_matrix.solve_right(
    vector(QQ, list(small_Y_value))
)
small_Y_in_small_X = sum(
    small_Y_coefficients[i]*u^i for i in range(5)
)
assert embed_small_X(small_Y_in_small_X) == small_Y_value
print("SMALL_X_MINPOLY=%s" % small_X_value.minpoly())
print("SMALL_Y_AS_POLYNOMIAL_IN_SMALL_X=%s" % small_Y_in_small_X)
print("SMALL_MODEL_RELATION_VERIFIED=true")
