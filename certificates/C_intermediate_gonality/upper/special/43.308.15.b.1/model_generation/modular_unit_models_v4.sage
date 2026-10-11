from sage.all import *
from sage.misc.cachefunc import cached_function
import itertools
import time

MODULAR_UNIT_MODELS_VERSION = "2026-07-15-v4"
print("[MU model library] loaded version %s" % MODULAR_UNIT_MODELS_VERSION, flush=True)

# Plane models for intermediate modular curves X_Delta(N) from modular units.
#
# This file is meant to be loaded AFTER modular_units_lib.sage:
#
#     load("modular_units_lib.sage")
#     load("modular_unit_models.sage")
#     M = modular_unit_plane_model(N, delta_generators)
#     print(M["polynomial"])
#
# If the library has not yet been loaded, we try to load it from the current
# working directory.
#
# MATHEMATICAL IDEA
# -----------------
# 1. modular_units_lib.sage computes L3, the exact lattice of modular units on
#    X_Delta(N), represented by their divisors and by exponent vectors in the
#    standard basis F_2,...,F_(floor(N/2)+1).
#
# 2. Equations (36)--(37) of van Hoeij--Smith express every F_k exactly as a
#    product of Streng's Siegel functions H_j = g_(0,j/N).  Hence an exponent
#    vector in the F-basis gives an exact q-expansion at the standard cusp.
#
# 3. For two descended modular units x,y of degrees d_x,d_y, their minimal
#    relation lies in the rectangle
#
#        sum_{0 <= i <= d_y, 0 <= j <= d_x} c_(i,j) X^i Y^j.
#
# 4. We solve for the c_(i,j) from exact cyclotomic q-expansions.  This is made
#    rigorous, rather than heuristic, as follows.  Let D be a common pole
#    divisor for every monomial in the rectangle and let B=deg(D).  A nonzero
#    function with poles bounded by D cannot vanish to order > B at one
#    geometric point.  Therefore vanishing through q^B proves the relation
#    identically.  The cusp C_0 is always unramified in X_1(N)->X_Delta(N), so
#    q is also a local parameter downstairs.
#
# 5. If the irreducible relation P satisfies
#
#        deg_Y(P) = deg(x)  and  deg_X(P) = deg(y),
#
#    then Q(x,y) has the same degree over Q(x) as Q(X_Delta(N)); hence x,y
#    generate the full function field.  This certifies that P=0 is birational
#    to X_Delta(N), without needing a pre-existing model or a genus routine.


try:
    modular_unit_lattices
except NameError:
    load("modular_units_lib.sage")


def _model_log(enabled, prefix, message):
    if enabled:
        print("[%s] %s" % (prefix, message), flush=True)


# -------------------------------------------------------------------------
# 1. Exact Siegel q-expansions
# -------------------------------------------------------------------------


@cached_function
def _cyclotomic_model_field(N):
    """A field containing every coefficient and leading constant we need."""
    return CyclotomicField(2*ZZ(N))


def _siegel_product_qexpansion(N, H_exponents, absolute_precision):
    r"""Exact Laurent expansion of product H_k^a_k to O(q^P).

    Here H_k = g_(0,k/N), using the normalization in van Hoeij--Smith and
    Streng.  Definition 6.1 gives

      H_k = (zeta_(2N)^k-zeta_(2N)^(-k)) q^(1/12)
            * product_{n>=1}(1-zeta_N^k q^n)(1-zeta_N^(-k) q^n).

    The input is required to satisfy Streng's congruences, in particular
    sum(a_k) is divisible by 12, so the resulting q-order is integral.

    `absolute_precision=P` means that the result is correct modulo O(q^P),
    even when it has negative valuation.
    """
    N = ZZ(N)
    P = ZZ(absolute_precision)
    m = N//2
    a = vector(ZZ, H_exponents)

    if len(a) != m:
        raise ValueError("wrong number of Siegel exponents")

    A0 = ZZ(sum(a))
    A2 = ZZ(sum(k*k*a[k-1] for k in range(1, m+1)))
    if A0 % 12 != 0 or A2 % (N*gcd(N, 2)) != 0:
        raise ValueError("the H-exponents do not define a Q-rational modular unit")

    q_order = A0//12
    if P <= q_order:
        raise ValueError("absolute precision must exceed the q-order")

    # The Euler product after removing q^q_order must be known through
    # q^(P-q_order-1).
    work_precision = ZZ(P - q_order)
    K = _cyclotomic_model_field(N)
    eta = K.gen()                         # primitive (2N)-th root

    PS = PowerSeriesRing(K, "q",
                         default_prec=max(20, int(work_precision)+2))

    leading_constant = K.one()
    zeta = eta**2                         # primitive N-th root
    nonzero_exponents = [
        (k, ZZ(a[k-1])) for k in range(1, m+1) if a[k-1] != 0
    ]

    for k, exponent in nonzero_exponents:
        leading_constant *= (eta**k - eta**(-k))**exponent

    # Compute the Euler product by logarithm and formal exponentiation.
    # This is much faster than multiplying thousands of truncated factors.
    # If P(q) is the product after removing its leading constant and q-order,
    # then
    #
    #   [q^r] log P = -sum_{j|r} (1/j)
    #                   sum_k a_k(zeta^(kj)+zeta^(-kj)).
    #
    # From P'=P*(log P)' we obtain
    #
    #   n*p_n = sum_{j=1}^n j*l_j*p_(n-j).
    M = int(work_precision)
    power_sums = [K.zero()] * M
    for j in range(1, M):
        power_sums[j] = sum(
            (exponent*(zeta**(k*j) + zeta**(-k*j))
             for k, exponent in nonzero_exponents),
            K.zero()
        )

    log_coefficients = [K.zero()] * M
    for r in range(1, M):
        log_coefficients[r] = -sum(
            (power_sums[j]/j for j in divisors(r)),
            K.zero()
        )

    product_coefficients = [K.zero()] * M
    product_coefficients[0] = K.one()
    for n in range(1, M):
        product_coefficients[n] = sum(
            (j*log_coefficients[j]*product_coefficients[n-j]
             for j in range(1, n+1)),
            K.zero()
        )/n

    product_series = PS(product_coefficients).add_bigoh(work_precision)

    LS = LaurentSeriesRing(K, "q",
                           default_prec=max(20, int(work_precision)+2))
    qL = LS.gen()
    answer = (LS(leading_constant) * qL**q_order
              * LS(product_series)).add_bigoh(P)

    if answer.valuation() != q_order:
        raise ArithmeticError("Siegel product has an unexpected q-order")

    return answer


def modular_unit_qexpansion(N, F_exponents, absolute_precision):
    r"""Exact q-expansion of an F-monomial at the standard cusp C_0.

    `F_exponents` are ordered as F_2,...,F_(floor(N/2)+1).
    The output is a Laurent series over Q(zeta_(2N)), correct modulo
    O(q^absolute_precision).
    """
    e = vector(ZZ, F_exponents)
    FH = F_to_H_matrix(N)
    if len(e) != FH.nrows():
        raise ValueError("wrong number of F-exponents")
    a = e*FH
    return _siegel_product_qexpansion(N, a, absolute_precision)


@cached_function
def check_model_qexpansion_normalization():
    r"""Exact small-level check of all constants in the Siegel expansion.

    On X_1(5), Tate normal form gives C=B and therefore

        F_2*F_3*(F_3^2+11*F_3-1)+1 = 0.

    This check is sensitive to the leading constants and signs, not only to
    cusp valuations.  It is run once before model construction.

    We deliberately compute the input series to *more* precision than the
    number of coefficients being checked.  F_2 has a pole at C_0, and
    multiplying a truncated Laurent series by a pole lowers its absolute
    precision.  Using the same precision for input and output was the source
    of an IndexError in the first version of this file.
    """
    check_precision = ZZ(12)
    input_precision = check_precision + 8
    F2 = modular_unit_qexpansion(5, [1, 0], input_precision)
    F3 = modular_unit_qexpansion(5, [0, 1], input_precision)

    R = PolynomialRing(ZZ, 2, names=("X", "Y"))
    X, Y = R.gens()
    relation = X*Y*(Y**2 + 11*Y - 1) + 1
    value = _evaluate_polynomial_in_series(
        relation, F2, F3, check_precision
    )

    _require_series_precision(
        value, check_precision,
        "X_1(5) Siegel-normalization test"
    )

    # Do not access coefficients one by one here.  Sage deliberately raises
    # IndexError when a coefficient lies at the unknown precision boundary.
    # The statement that the relation vanishes modulo O(q^check_precision) is
    # exactly the valuation inequality below.
    if value.valuation() < check_precision:
        raise ArithmeticError(
            "Siegel q-expansion normalization failed the X_1(5) test: "
            "the first nonzero term has exponent %s, but at least %s was "
            "required" % (value.valuation(), check_precision)
        )
    return True


@cached_function
def check_model_level_formulas(N):
    """Verify the F/H divisor conversion and diamond permutation at level N."""
    return check_formulas(ZZ(N))


# -------------------------------------------------------------------------
# 2. Short descended modular units to use as coordinates
# -------------------------------------------------------------------------


def _canonical_sign_vector(v):
    """Choose one of v,-v by making the first nonzero coordinate positive."""
    v = vector(ZZ, v)
    for x in v:
        if x > 0:
            return v
        if x < 0:
            return -v
    return v


def _weighted_lll_rows(Q, cusp_degrees):
    """LLL-reduce after weighting each cusp coordinate by its closed degree."""
    weights = vector(ZZ, cusp_degrees)
    W = diagonal_matrix(ZZ, list(weights))
    Qw = Q*W

    try:
        reduced = Qw.LLL()
    except Exception:
        reduced = Qw

    rows = []
    for rw in reduced.rows():
        entries = []
        for j in range(Q.ncols()):
            if rw[j] % weights[j] != 0:
                raise ArithmeticError("weighted LLL lost coordinate divisibility")
            entries.append(rw[j]//weights[j])
        rows.append(vector(ZZ, entries))
    return rows


def _add_unit_candidate(candidate_map, divisor, Q, E, cusp_degrees,
                        source="unknown"):
    """Add a nonzero L3 divisor, deduplicated up to inversion."""
    v = _canonical_sign_vector(divisor)
    if v == 0:
        return

    key = tuple(ZZ(x) for x in v)
    if key in candidate_map:
        return

    coordinates = _coordinates_in_rows(matrix(ZZ, [v]), Q).row(0)
    if coordinates*Q != v:
        raise ArithmeticError("candidate is not reconstructed in L3")

    F_exponents = coordinates*E
    degree = positive_degree(v, cusp_degrees)
    if positive_degree(-v, cusp_degrees) != degree:
        raise ArithmeticError("candidate divisor does not have degree zero")

    candidate_map[key] = {
        "degree": ZZ(degree),
        "downstairs_divisor": v,
        "L3_basis_coordinates": coordinates,
        "F_exponents": F_exponents,
        "function": F_monomial_string(F_exponents),
        "complexity": ZZ(sum(abs(x) for x in F_exponents)),
        "source": source,
    }


def _collect_unit_candidates(R, N, delta_generators,
                             degree_bound, max_candidates=30,
                             diagnostics=True,
                             progress_interval=200000):
    r"""Collect low-degree, pairwise distinct modular units in L3.

    Sources are:
      * the exact minimum-degree unit;
      * a cusp-degree-weighted LLL basis and small combinations of it;
      * exact collisions of effective cusp divisors through `degree_bound`.
    """
    prefix = "MU model N=%s candidates" % N
    Q = R["L3_downstairs_divisors"]
    E = R["L3_unit_exponents"]
    Delta = R["Delta"]
    cusp_degrees = downstairs_cusp_degrees(N, Delta)

    candidates = {}

    # Exact minimum, reusing the already constructed L3 lattice.
    t0 = time.perf_counter()
    min_degree, min_coordinates, min_divisor, _ = \
        _find_minimum_downstairs_divisor(
            Q, cusp_degrees,
            diagnostics=False,
            max_degree=None,
            progress_interval=progress_interval,
            prefix=prefix
        )
    _add_unit_candidate(candidates, min_divisor, Q, E, cusp_degrees,
                        source="minimum")
    _model_log(diagnostics, prefix,
               "minimum degree %s obtained in %.3fs"
               % (min_degree, time.perf_counter()-t0))

    # LLL basis and a few very small combinations.
    lll_rows = _weighted_lll_rows(Q, cusp_degrees)
    for row in lll_rows:
        _add_unit_candidate(candidates, row, Q, E, cusp_degrees,
                            source="weighted LLL")

    small_rows = lll_rows[:min(5, len(lll_rows))]
    for coeffs in itertools.product([-1, 0, 1], repeat=len(small_rows)):
        if not any(coeffs):
            continue
        v = sum((ZZ(coeffs[i])*small_rows[i]
                 for i in range(len(small_rows))),
                zero_vector(ZZ, Q.ncols()))
        if v != 0 and positive_degree(v, cusp_degrees) <= degree_bound:
            _add_unit_candidate(candidates, v, Q, E, cusp_degrees,
                                source="small LLL combination")
        if len(candidates) >= max_candidates:
            break

    # Exact degree-by-degree collision enumeration.  At degrees after the
    # minimum, two effective divisors may share support, so we retain the
    # reduced difference whenever its actual degree is within the bound.
    class_data = _smith_class_data(Q)
    weights = vector(ZZ, cusp_degrees)
    degree_step = ZZ(gcd(weights))
    degree = ZZ(min(weights))

    while degree <= degree_bound and len(candidates) < max_candidates:
        seen = {}
        count = 0
        start = time.perf_counter()

        for effective in _effective_cusp_divisors(weights, degree):
            count += 1
            key = _smith_class_key(effective, class_data)
            previous_list = seen.get(key)

            if previous_list is None:
                seen[key] = [effective]
            else:
                # Two representatives per class give more diversity without
                # allowing the storage to explode.
                for previous in previous_list:
                    difference = vector(ZZ, [
                        effective[i]-previous[i]
                        for i in range(len(effective))
                    ])
                    actual_degree = positive_degree(difference, cusp_degrees)
                    if difference != 0 and actual_degree <= degree_bound:
                        _add_unit_candidate(
                            candidates, difference, Q, E, cusp_degrees,
                            source="effective-divisor collision"
                        )
                        if len(candidates) >= max_candidates:
                            break
                if len(previous_list) < 2:
                    previous_list.append(effective)

            if len(candidates) >= max_candidates:
                break

            if diagnostics and progress_interval and count % progress_interval == 0:
                _model_log(True, prefix,
                           "degree %s: checked %s effective divisors; candidates=%s"
                           % (degree, count, len(candidates)))

        _model_log(diagnostics, prefix,
                   "degree %s: checked %s effective divisors in %.3fs; "
                   "candidates=%s"
                   % (degree, count, time.perf_counter()-start,
                      len(candidates)))
        degree += degree_step

    answer = sorted(
        candidates.values(),
        key=lambda c: (c["degree"], c["complexity"],
                       max(abs(x) for x in c["F_exponents"]),
                       tuple(c["F_exponents"]))
    )

    _model_log(diagnostics, prefix,
               "returning %s candidates through degree %s"
               % (len(answer), degree_bound))
    return answer


# -------------------------------------------------------------------------
# 3. Exact relation recovery and certification
# -------------------------------------------------------------------------


def _common_pole_degree(vx, vy, dx, dy, cusp_degrees):
    r"""Degree of a common pole divisor for X^i Y^j in the full rectangle.

    The rectangle is 0<=i<=dy and 0<=j<=dx because the expected relation has
    degree dy in X and dx in Y.
    """
    pole_coefficients = []
    for j in range(len(cusp_degrees)):
        pole = dy*max(-ZZ(vx[j]), 0) + dx*max(-ZZ(vy[j]), 0)
        pole_coefficients.append(ZZ(pole))

    bound = ZZ(sum(cusp_degrees[j]*pole_coefficients[j]
                   for j in range(len(cusp_degrees))))
    return bound, vector(ZZ, pole_coefficients)


def _series_absolute_precision(series):
    """Return the absolute precision of a (Laurent) series."""
    try:
        return series.precision_absolute()
    except AttributeError:
        # Exact constants in some Sage parents do not expose a precision.
        return Infinity


def _require_series_precision(series, required_precision, context):
    """Raise a descriptive error if q^n is unknown below the requested bound."""
    known = _series_absolute_precision(series)
    if known < required_precision:
        raise ArithmeticError(
            "%s is known only modulo O(q^%s), but O(q^%s) is required"
            % (context, known, required_precision)
        )


def _series_powers(series, maximum_power):
    r"""Return 1,series,...,series^maximum_power without losing precision.

    The constant 1 is kept exact, and intermediate powers are *not* truncated.
    Truncating each intermediate power to the final target precision is wrong
    when ``series`` has negative valuation: the next multiplication shifts the
    artificial O(q^P) error downwards.  Final monomials are truncated only
    after their precision has been checked.
    """
    ring = series.parent()
    powers = [ring(1)]
    for _ in range(maximum_power):
        powers.append(powers[-1]*series)
    return powers


def _polynomial_from_kernel_vector(ring, monomials, vector_coefficients):
    X, Y = ring.gens()
    return ring.sum(vector_coefficients[k]
                    * X**monomials[k][0] * Y**monomials[k][1]
                    for k in range(len(monomials)))


def _primitive_integer_polynomial(P):
    r"""Convert a cyclotomic polynomial known up to scalar to primitive Z[X,Y].

    After dividing by one nonzero coefficient, every coefficient must be
    rational.  Failure of this check means that either the q-expansion
    normalization is wrong or the input did not define Q-rational functions.
    """
    if P == 0:
        raise ValueError("zero polynomial")

    # Normalize over the cyclotomic field first.
    lc = P.leading_coefficient()
    P = P/lc

    rational_coefficients = {}
    for exponent, coefficient in P.dict().items():
        try:
            rational_coefficients[exponent] = QQ(coefficient)
        except (TypeError, ValueError):
            raise ArithmeticError(
                "the recovered relation is not defined over Q after scalar "
                "normalization; please send the diagnostics"
            )

    denominators = [c.denominator()
                    for c in rational_coefficients.values()]
    common_denominator = lcm(denominators) if denominators else ZZ(1)
    integer_coefficients = {
        exponent: ZZ(common_denominator*coefficient)
        for exponent, coefficient in rational_coefficients.items()
    }

    content = gcd([abs(c) for c in integer_coefficients.values()
                   if c != 0])
    if content == 0:
        raise ArithmeticError("relation became zero during normalization")

    integer_coefficients = {
        exponent: coefficient//content
        for exponent, coefficient in integer_coefficients.items()
    }

    RZ = PolynomialRing(ZZ, 2, names=("X", "Y"))
    answer = RZ(integer_coefficients)
    if answer.leading_coefficient() < 0:
        answer = -answer
    return answer


def _evaluate_polynomial_in_series(P, x_series, y_series,
                                   absolute_precision):
    """Evaluate a bivariate polynomial with certified Laurent precision."""
    max_x = P.degree(P.parent().gen(0))
    max_y = P.degree(P.parent().gen(1))
    xp = _series_powers(x_series, max_x)
    yp = _series_powers(y_series, max_y)

    ring = x_series.parent()
    result = ring(0)                 # exact zero, not 0 + O(q^P)
    for (i, j), coefficient in P.dict().items():
        term = coefficient*xp[i]*yp[j]
        _require_series_precision(
            term, absolute_precision,
            "the term X^%s Y^%s during polynomial evaluation" % (i, j)
        )
        result += term.add_bigoh(absolute_precision)

    _require_series_precision(
        result, absolute_precision, "the evaluated polynomial"
    )
    return result.add_bigoh(absolute_precision)


def _recover_certified_relation(N, Delta, fibers,
                                x_candidate, y_candidate,
                                cusp_degrees, diagnostics=True,
                                qexpansion_cache=None):
    r"""Recover and certify the minimal relation of two modular units."""
    prefix = "MU model N=%s relation" % N

    vx = x_candidate["downstairs_divisor"]
    vy = y_candidate["downstairs_divisor"]
    dx = ZZ(x_candidate["degree"])
    dy = ZZ(y_candidate["degree"])

    pole_bound, pole_divisor = _common_pole_degree(
        vx, vy, dx, dy, cusp_degrees
    )
    certification_precision = pole_bound + 1

    # Locate the downstairs cusp below C_0.  C_0 is unramified for every
    # diamond quotient, hence q is a local parameter on the quotient as well.
    zero_cusp = None
    for j, (orbit, ramification) in enumerate(fibers):
        if 0 in orbit:
            zero_cusp = j
            if ramification != 1:
                raise ArithmeticError("C_0 should be unramified")
            break
    if zero_cusp is None:
        raise ArithmeticError("could not locate the cusp below C_0")

    vx0 = ZZ(vx[zero_cusp])
    vy0 = ZZ(vy[zero_cusp])
    minimum_monomial_order = (dy*min(vx0, 0) + dx*min(vy0, 0))

    # A base series must be known more accurately than the final monomials
    # when it has a pole: multiplication by negative-valuation factors shifts
    # truncation errors downward.  The formula below is a good initial bound;
    # we then inspect the *actual Sage precision* of every monomial and
    # automatically increase it if necessary.  Hence no precision assumption
    # is trusted without verification.
    base_precision = certification_precision - minimum_monomial_order

    _model_log(diagnostics, prefix,
               "trying degrees (%s,%s); monomials=%s; pole bound=%s; "
               "initial q precision=%s"
               % (dx, dy, (dy+1)*(dx+1), pole_bound, base_precision))

    t0 = time.perf_counter()

    if qexpansion_cache is None:
        qexpansion_cache = {}

    def cached_expansion(candidate, requested_precision):
        key = tuple(ZZ(x) for x in candidate["F_exponents"])
        previous = qexpansion_cache.get(key)
        if previous is not None and previous[0] >= requested_precision:
            return previous[1].add_bigoh(requested_precision)
        series = modular_unit_qexpansion(
            N, candidate["F_exponents"], requested_precision
        )
        qexpansion_cache[key] = (requested_precision, series)
        return series

    monomial_exponents = [(i, j)
                          for i in range(dy+1)
                          for j in range(dx+1)]

    # Construct the monomials with adaptive input precision.  Intermediate
    # powers retain all available precision; only completed monomials are
    # truncated to the certification bound.
    working_precision = ZZ(base_precision)
    for precision_attempt in range(1, 9):
        step = time.perf_counter()
        _model_log(diagnostics, prefix,
                   "computing q-expansions of X and Y to O(q^%s), attempt %s"
                   % (working_precision, precision_attempt))
        x_series = cached_expansion(x_candidate, working_precision)
        y_series = cached_expansion(y_candidate, working_precision)
        _model_log(diagnostics, prefix,
                   "coordinate q-expansions finished in %.3fs"
                   % (time.perf_counter()-step))

        if x_series.valuation() != vx0 or y_series.valuation() != vy0:
            raise ArithmeticError(
                "q-orders do not match the computed cusp divisors"
            )

        step = time.perf_counter()
        _model_log(diagnostics, prefix,
                   "building monomial expansions with certified precision")
        xp = _series_powers(x_series, dy)
        yp = _series_powers(y_series, dx)

        monomial_series = []
        largest_deficit = ZZ(0)
        worst_monomial = None
        worst_known_precision = None
        for (i, j) in monomial_exponents:
            raw = xp[i]*yp[j]
            known = _series_absolute_precision(raw)
            if known < certification_precision:
                deficit = ZZ(certification_precision - known)
                if deficit > largest_deficit:
                    largest_deficit = deficit
                    worst_monomial = (i, j)
                    worst_known_precision = known
            else:
                monomial_series.append(
                    raw.add_bigoh(certification_precision)
                )

        if largest_deficit == 0:
            _model_log(diagnostics, prefix,
                       "monomial expansions finished in %.3fs; all are known "
                       "through O(q^%s)"
                       % (time.perf_counter()-step,
                          certification_precision))
            break

        _model_log(diagnostics, prefix,
                   "precision O(q^%s) was insufficient: X^%s Y^%s is known "
                   "only through O(q^%s); increasing by %s"
                   % (working_precision, worst_monomial[0],
                      worst_monomial[1], worst_known_precision,
                      largest_deficit + 4))
        working_precision += largest_deficit + 4
    else:
        raise ArithmeticError(
            "could not obtain sufficient Laurent precision after 8 attempts"
        )

    coefficient_exponents = range(int(minimum_monomial_order),
                                  int(certification_precision))
    K = x_series.base_ring()
    step = time.perf_counter()
    _model_log(diagnostics, prefix,
               "building relation matrix with %s rows and %s columns"
               % (len(coefficient_exponents), len(monomial_series)))
    relation_matrix = matrix(K, [
        [series[n] for series in monomial_series]
        for n in coefficient_exponents
    ])
    _model_log(diagnostics, prefix,
               "relation matrix built in %.3fs; computing exact kernel"
               % (time.perf_counter()-step))

    step = time.perf_counter()
    kernel = relation_matrix.right_kernel().basis_matrix()
    _model_log(diagnostics, prefix,
               "kernel computed in %.3fs; dimension=%s"
               % (time.perf_counter()-step, kernel.nrows()))
    if kernel.nrows() == 0:
        raise ArithmeticError(
            "no relation was found in the theoretically sufficient rectangle"
        )

    KXY = PolynomialRing(K, 2, names=("X", "Y"))
    kernel_polynomials = [
        _polynomial_from_kernel_vector(KXY, monomial_exponents, row)
        for row in kernel.rows()
        if row != 0
    ]
    if not kernel_polynomials:
        raise ArithmeticError("the relation kernel unexpectedly contains no polynomial")

    step = time.perf_counter()
    _model_log(diagnostics, prefix, "extracting the gcd of kernel relations")
    relation_K = kernel_polynomials[0]
    for other in kernel_polynomials[1:]:
        relation_K = relation_K.gcd(other)
    _model_log(diagnostics, prefix,
               "kernel-relation gcd finished in %.3fs"
               % (time.perf_counter()-step))
    if relation_K.degree() <= 0:
        raise ArithmeticError("the gcd of the relation space is constant")

    relation_ZZ = _primitive_integer_polynomial(relation_K)

    # Independent exact certification.  All coefficients from the smallest
    # possible order through q^B must vanish.  Then ord_C0(P(x,y)) > B while
    # its total pole degree is <=B, forcing P(x,y)=0 identically.
    evaluated = _evaluate_polynomial_in_series(
        relation_ZZ, x_series, y_series, certification_precision
    )
    # As in the normalization test, valuation is the robust way to certify
    # zero modulo O(q^certification_precision); it avoids probing Sage's
    # unknown boundary coefficient.
    if evaluated.valuation() < certification_precision:
        raise ArithmeticError(
            "candidate relation failed q-expansion certification: first "
            "nonzero exponent is %s, required at least %s"
            % (evaluated.valuation(), certification_precision)
        )

    RX = relation_ZZ.parent()
    X, Y = RX.gens()
    degree_in_X = ZZ(relation_ZZ.degree(X))
    degree_in_Y = ZZ(relation_ZZ.degree(Y))

    # Sage 10.6's libSingular multivariate polynomial elements do not
    # implement ``is_irreducible()``.  Over QQ[X,Y], however, irreducible
    # elements are exactly prime elements, and ``is_prime()`` is implemented
    # by the multivariate backend.  Keep a factorization fallback for other
    # Sage backends/versions.
    relation_QQ = relation_ZZ.change_ring(QQ)
    try:
        irreducible = bool(relation_QQ.is_prime())
    except (AttributeError, NotImplementedError):
        factorization = relation_QQ.factor()
        irreducible = (len(factorization) == 1
                       and ZZ(factorization[0][1]) == 1)

    birational = (irreducible
                  and degree_in_Y == dx
                  and degree_in_X == dy)

    _model_log(diagnostics, prefix,
               "kernel dimension=%s; relation bidegree=(%s,%s); "
               "irreducible=%s; birational=%s; elapsed=%.3fs"
               % (kernel.nrows(), degree_in_X, degree_in_Y,
                  irreducible, birational, time.perf_counter()-t0))

    return {
        "polynomial": relation_ZZ,
        "degree_in_X": degree_in_X,
        "degree_in_Y": degree_in_Y,
        "irreducible": irreducible,
        "birational": birational,
        "pole_bound": pole_bound,
        "common_pole_divisor": pole_divisor,
        "certification_precision": certification_precision,
        "kernel_dimension": kernel.nrows(),
    }


# -------------------------------------------------------------------------
# 4. Public model constructor
# -------------------------------------------------------------------------


def modular_unit_plane_model(
        N, delta_generators,
        candidate_degree_bound=None,
        max_candidate_degree=None,
        max_candidates=30,
        pair_candidate_limit=16,
        max_pairs=120,
        diagnostics=True,
        progress_interval=200000):
    r"""Construct a certified affine plane model of X_Delta(N).

    OUTPUT
    ------
    A dictionary containing:

      polynomial          primitive P(X,Y) in Z[X,Y]
      X_function          X as an F_2,...,F_(floor(N/2)+1) monomial
      Y_function          Y as an F-monomial
      X_degree, Y_degree  degrees of the two maps to P^1
      X_F_exponents, Y_F_exponents
      X_divisor, Y_divisor downstairs
      birational          always True for a returned result

    CORRECTNESS CERTIFICATE
    -----------------------
    The returned polynomial is certified by a q-expansion order exceeding a
    global pole-degree bound.  Birationality is certified by irreducibility
    and the two degree equalities

        deg_Y(P)=deg(X),  deg_X(P)=deg(Y).

    LIMITATION
    ----------
    This method needs at least two independent descended modular units.  It
    may fail to find a good pair inside the requested candidate bounds, in
    which case it raises a descriptive error rather than returning an
    uncertified equation.
    """
    N = ZZ(N)
    prefix = "MU model N=%s" % N
    total_start = time.perf_counter()

    if N < 4:
        raise NotImplementedError("model construction is implemented for N >= 4")

    _model_log(diagnostics, prefix,
               "starting model construction; generators=%s"
               % list(delta_generators))

    # One cached exact test checks the leading constants/signs in the Siegel
    # product formula, not merely its divisor.  Print these stages explicitly:
    # if a normalization or convention is ever wrong, the failure location is
    # immediately visible in the transcript.
    _model_log(diagnostics, prefix,
               "running exact X_1(5) q-expansion normalization test")
    check_model_qexpansion_normalization()
    _model_log(diagnostics, prefix,
               "normalization test passed; checking level-%s divisor and "
               "diamond formulas" % N)
    check_model_level_formulas(N)
    _model_log(diagnostics, prefix,
               "level-%s formula checks passed" % N)

    t0 = time.perf_counter()
    R = modular_unit_lattices(N, delta_generators, verbose=diagnostics)
    Delta = R["Delta"]
    fibers = R["fibers"]
    Q = R["L3_downstairs_divisors"]
    cusp_degrees = downstairs_cusp_degrees(N, Delta)

    if Q.nrows() < 2:
        raise ValueError(
            "L3 has rank %s; two independent modular-unit coordinates do not exist"
            % Q.nrows()
        )

    minimum_degree, _, _, _ = _find_minimum_downstairs_divisor(
        Q, cusp_degrees, diagnostics=False
    )
    basis_upper_bound = _minimum_known_degree_from_basis(Q, cusp_degrees)

    if candidate_degree_bound is None:
        candidate_degree_bound = max(
            ZZ(minimum_degree)+4,
            ZZ(basis_upper_bound)
        )
    else:
        candidate_degree_bound = ZZ(candidate_degree_bound)

    if max_candidate_degree is None:
        max_candidate_degree = max(
            candidate_degree_bound,
            2*ZZ(basis_upper_bound)+4,
            2*ZZ(minimum_degree)+8
        )
    else:
        max_candidate_degree = ZZ(max_candidate_degree)

    _model_log(diagnostics, prefix,
               "L3 rank=%s; minimum degree=%s; basis upper bound=%s; "
               "initial candidate bound=%s; maximum candidate bound=%s"
               % (Q.nrows(), minimum_degree, basis_upper_bound,
                  candidate_degree_bound, max_candidate_degree))
    _model_log(diagnostics, prefix,
               "lattice setup finished in %.3fs"
               % (time.perf_counter()-t0))

    tried_pair_keys = set()
    pairs_tried = 0
    current_bound = candidate_degree_bound
    qexpansion_cache = {}

    while current_bound <= max_candidate_degree:
        candidates = _collect_unit_candidates(
            R, N, delta_generators,
            degree_bound=current_bound,
            max_candidates=max_candidates,
            diagnostics=diagnostics,
            progress_interval=progress_interval
        )

        limited = list(candidates[:min(pair_candidate_limit, len(candidates))])

        # Always retain the weighted-LLL basis as a source of independent
        # directions, even if many same-degree collision vectors sort ahead
        # of it.
        limited_keys = {tuple(c["downstairs_divisor"]) for c in limited}
        for candidate in candidates:
            if candidate["source"] == "weighted LLL":
                key = tuple(candidate["downstairs_divisor"])
                if key not in limited_keys:
                    limited.append(candidate)
                    limited_keys.add(key)

        pair_indices = []
        for i in range(len(limited)):
            for j in range(i+1, len(limited)):
                x = limited[i]
                y = limited[j]
                if matrix(QQ, [x["downstairs_divisor"],
                               y["downstairs_divisor"]]).rank() < 2:
                    continue
                score = (
                    x["degree"]*y["degree"],
                    x["degree"]+y["degree"],
                    max(x["degree"], y["degree"]),
                    x["complexity"]+y["complexity"],
                    i, j
                )
                pair_indices.append((score, i, j))
        pair_indices.sort()

        _model_log(diagnostics, prefix,
                   "candidate bound %s produced %s units and %s independent pairs"
                   % (current_bound, len(candidates), len(pair_indices)))

        for _, i, j in pair_indices:
            if pairs_tried >= max_pairs:
                break

            x_candidate = limited[i]
            y_candidate = limited[j]
            pair_key = (tuple(x_candidate["downstairs_divisor"]),
                        tuple(y_candidate["downstairs_divisor"]))
            if pair_key in tried_pair_keys:
                continue
            tried_pair_keys.add(pair_key)
            pairs_tried += 1

            _model_log(diagnostics, prefix,
                       "pair %s: deg(X)=%s, deg(Y)=%s; X=%s; Y=%s"
                       % (pairs_tried,
                          x_candidate["degree"], y_candidate["degree"],
                          x_candidate["function"], y_candidate["function"]))

            try:
                relation_data = _recover_certified_relation(
                    N, Delta, fibers,
                    x_candidate, y_candidate,
                    cusp_degrees,
                    diagnostics=diagnostics,
                    qexpansion_cache=qexpansion_cache
                )
            except Exception as error:
                _model_log(diagnostics, prefix,
                           "pair %s failed: %s: %s"
                           % (pairs_tried, type(error).__name__, error))
                continue

            if not relation_data["birational"]:
                _model_log(diagnostics, prefix,
                           "pair %s defines a proper subfield; trying another pair"
                           % pairs_tried)
                continue

            polynomial = relation_data["polynomial"]
            _model_log(diagnostics, prefix,
                       "certified model found after %s pairs in %.3fs"
                       % (pairs_tried, time.perf_counter()-total_start))
            _model_log(diagnostics, prefix,
                       "P(X,Y) = %s" % polynomial)

            return {
                "polynomial": polynomial,
                "X_function": x_candidate["function"],
                "Y_function": y_candidate["function"],
                "X_degree": x_candidate["degree"],
                "Y_degree": y_candidate["degree"],
                "X_F_exponents": x_candidate["F_exponents"],
                "Y_F_exponents": y_candidate["F_exponents"],
                "X_divisor": x_candidate["downstairs_divisor"],
                "Y_divisor": y_candidate["downstairs_divisor"],
                "X_source": x_candidate["source"],
                "Y_source": y_candidate["source"],
                "Delta": Delta,
                "fibers": fibers,
                "downstairs_cusp_degrees": cusp_degrees,
                "birational": True,
                "relation_certificate": relation_data,
                "pairs_tried": pairs_tried,
                "candidate_degree_bound": current_bound,
                "elapsed_seconds": time.perf_counter()-total_start,
            }

        if pairs_tried >= max_pairs:
            break

        increment = max(ZZ(2), ZZ(minimum_degree)//2)
        current_bound += increment
        _model_log(diagnostics, prefix,
                   "no generating pair yet; increasing candidate bound to %s"
                   % current_bound)

    raise RuntimeError(
        "no certified modular-unit model was found after %s pairs and "
        "candidate degrees through %s; increase max_candidates, "
        "pair_candidate_limit, max_pairs, or max_candidate_degree and send "
        "the diagnostic output"
        % (pairs_tried, min(current_bound, max_candidate_degree))
    )


# Short alias.
modular_unit_model = modular_unit_plane_model


# Example
# -------
# load("modular_units_lib.sage")
# load("modular_unit_models.sage")
# M = modular_unit_plane_model(24, [23, 5])
# print(M["polynomial"])
# print("X =", M["X_function"])
# print("Y =", M["Y_function"])
