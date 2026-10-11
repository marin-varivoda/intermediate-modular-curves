from sage.all import *
from sage.misc.cachefunc import cached_function
import time

# Modular units on X_1(N), intermediate quotients X_Delta(N), and descent.
#
# This is the computational engine behind ../modular_units.ipynb.  It builds
# the lattice of Q-rational modular units on X_Delta(N) and finds one of
# globally lowest degree, which gives a rigorous upper bound on the
# Q-gonality of X_Delta(N) (a degree-d nonconstant rational function is a
# degree-d map to P^1).
#
# Public entry point:
#
#     lowest_degree_modular_unit(N, delta_generators)
#
# CUSP LABELS (Derickx--van Hoeij)
# --------------------------------
# The divisor columns are C_0,...,C_floor(N/2), NOT individual geometric cusps.
# C_i is the closed cusp (Galois orbit) determined by the second coordinate
#     c = +-i mod N
# of a primitive vector +-(a,c) in (Z/NZ)^2.  A divisor vector (v_i) means
# valuation v_i at every geometric cusp in C_i.  Diamond <u> sends
#     C_i  -->  C_can(u*i),
# where can(x) is the representative of {x,-x} in [0,floor(N/2)].
#
# ALGORITHM NOTES
# ---------------
# Sections 1-5 mirror the notebook exactly (same public functions, same
# semantics) but cache the per-N combinatorics with @cached_function so that
# repeated calls across many (N, Delta) pairs do not redo O(N^2) work.
#
# Section 7 replaces the notebook's per-cusp MILP degree search with an exact
# combinatorial search: enumerate effective cusp divisors degree-by-degree
# and stop as soon as two distinct divisors of the same degree collide modulo
# the L3 lattice (detected via a Smith-normal-form class map).  Their
# difference is then a lowest-degree element of L3.  This is both provably
# exact and, empirically, far faster than the MILP: on some subgroups the
# MILP relaxation degenerates and GLPK's branch-and-bound never returns,
# whereas the enumeration below always terminates quickly for the group
# orders relevant here (N <= 50).


def _log(enabled, prefix, message):
    if enabled:
        print("[%s] %s" % (prefix, message), flush=True)


def can(a, N):
    """Canonical representative modulo N, up to sign."""
    a = ZZ(a) % N
    return min(a, (-a) % N)


def diamond_subgroup(N, generators):
    """Subgroup Delta <= (Z/NZ)^*/{+-1}, returned as canonical integer reps."""
    gens = {can(g, N) for g in generators}
    if any(gcd(g, N) != 1 for g in gens):
        raise ValueError("diamond generators must be units modulo N")

    H = {can(1, N)}
    while True:
        new = set(H)
        for a in H:
            for b in H | gens:
                new.add(can(a*b, N))
        if new == H:
            return sorted(H)
        H = new


# 1. Van Hoeij--Smith cusp valuation matrix -------------------------------


@cached_function
def inverse_gcd(i, N):
    """The factor e_i(N) in the Van Hoeij program."""
    return ZZ(1) if (N, i) == (4, 2) else ZZ(N // gcd(i, N))


@cached_function
def degree_cusp(i, N):
    """Degree over Q of the closed cusp C_i."""
    d = euler_phi(gcd(i, N))
    return ceil(d/2) if i == 0 or 2*i == N else d


@cached_function
def min_formula(k, t):
    """Van Hoeij--Smith's unweighted piecewise-linear function v_k(t)."""
    k, t = ZZ(k), QQ(t)
    if k == 2:
        return 4*t - 1
    if k == 3:
        return 9*min(t, QQ(1)/3) - 8*t
    if k < 2:
        raise ValueError("k must be at least 2")
    return sum(
        k * QQ(euler_phi(gcd(j, k))) / gcd(j, k)
        * (min(t, QQ(j)/k) - 4*QQ(j)/k*(1-QQ(j)/k)*t)
        for j in range(1, (k-1)//2 + 1)
    )


@cached_function
def divisor_F(N, k):
    """Valuations of F_k at C_0,...,C_floor(N/2)."""
    v = vector(ZZ, [
        inverse_gcd(i, N) * min_formula(k, QQ(i)/N)
        for i in range(N//2 + 1)
    ])
    v.set_immutable()
    return v


@cached_function
def modular_unit_matrix(N):
    """Rows are div(F_2),...,div(F_floor(N/2)+1)."""
    M = matrix(ZZ, [divisor_F(N, k) for k in range(2, N//2 + 2)])
    M.set_immutable()
    return M


# 2. Cusps and ramification for X_1(N) -> X_Delta(N) ----------------------


def cusp_fibers(N, Delta):
    """Delta-orbits on the closed cusp labels C_i."""
    unseen = set(range(N//2 + 1))
    fibers = []
    while unseen:
        i = min(unseen)
        O = sorted({can(u*i, N) for u in Delta})
        fibers.append(O)
        unseen -= set(O)
    return fibers


def cusp_ramification(N, i, Delta):
    r"""Ramification index at a geometric cusp in C_i.

    Put d=gcd(i,N).  Its inertia subgroup consists of the u in Delta with
        u = +-1 mod lcm(d,N/d).
    """
    d = gcd(i, N)
    L = lcm(d, N//d)
    return ZZ(sum((u-1) % L == 0 or (u+1) % L == 0 for u in Delta))


def pullback_cusp_matrix(N, Delta):
    """Rows are pullbacks of the closed cusps of X_Delta(N)."""
    rows, data = [], []
    for O in cusp_fibers(N, Delta):
        e = cusp_ramification(N, O[0], Delta)
        assert all(cusp_ramification(N, i, Delta) == e for i in O)
        v = [0] * (N//2 + 1)
        for i in O:
            v[i] = e                     # pi^*(Q) = e * sum_{i in O} C_i
        rows.append(v)
        data.append((O, e))
    return matrix(ZZ, rows), data


# 3. Exact F_k -> Siegel H_k exponent conversion --------------------------
#
# Let H_k be Streng's Siegel functions and H~_k = H_k/H_1^(k^2).
# Equations (36)--(37) of van Hoeij--Smith give, up to a nonzero constant,
#
#   F_2 = H~_2^4,
#   F_3 = H~_3^3 / H~_2^8,
#   P_k = (H~_3/H~_2^3)^(k^2-1) H~_k
#       = F_3^floor(k^2/3) * product_{3<d|k} F_d.
#
# Constants do not affect g^*(f)/f, so this is enough to compute chi_f.


@cached_function
def _htilde_exponents(N, k):
    """H_1,...,H_floor(N/2) exponents of H~_k, up to a constant."""
    m = N//2
    j = can(k, N)
    if j == 0:
        raise ValueError("H_k is undefined when N divides k")
    v = zero_vector(ZZ, m)
    v[j-1] += 1
    v[0] -= k*k
    v.set_immutable()
    return v


@cached_function
def F_to_H_matrix(N):
    r"""Rows convert F-exponents to Siegel H-exponents.

    If e=(e_2,...,e_{m+1}), then
        a = e * F_to_H_matrix(N)
    satisfies, up to a nonzero constant,
        product F_k^e_k = product_{j=1}^m H_j^a_j.
    """
    if N < 3:
        raise NotImplementedError("the Siegel conversion is implemented for N >= 3")

    m = N//2
    F = {}
    F[2] = 4*_htilde_exponents(N, 2)
    if m >= 2:
        F[3] = 3*_htilde_exponents(N, 3) - 8*_htilde_exponents(N, 2)

    for k in range(4, m+2):
        Pk = ((k*k-1)
              * (_htilde_exponents(N, 3) - 3*_htilde_exponents(N, 2))
              + _htilde_exponents(N, k))
        Fk = Pk - (k*k//3)*F[3]
        for d in divisors(k):
            if 3 < d < k:
                Fk -= F[d]
        F[k] = Fk

    A = matrix(ZZ, [F[k] for k in range(2, m+2)])

    # Streng's criterion for a rational modular unit.
    for a in A.rows():
        assert sum(a) % 12 == 0
        assert sum((k+1)**2*a[k] for k in range(m)) % (N*gcd(N, 2)) == 0

    A.set_immutable()
    return A


# 4. Exact diamond sign on a Siegel product -------------------------------
#
# Work first in Streng's Gamma^1(N) convention.  For u in (Z/NZ)^*, choose
# M_u = [[u,N],[(u*d-1)/N,d]], where u*d=1 mod N.  The exact Siegel law gives
#
# H_k(M_u*tau) = eps(M_u) (-1)^k exp(pi*i*u*k^2/N) H_{u*k}.
#
# If u*k = q*N+r, 0<r<N, then H_{u*k}=(-1)^q H_can(r).  For a rational
# modular unit product H_k^a_k, sum(a_k) is divisible by 12, so eps disappears,
# and sum(k^2*a_k) is divisible by N*gcd(N,2), so the remaining multiplier is
# a sign.  Transporting from Gamma^1(N) to Gamma_1(N) changes each H_k only by
# a constant sign and therefore does not change chi_f.


def siegel_diamond_action(N, u, a):
    r"""Return (new_H_exponents, sign_bit) under diamond <u>.

    The multiplier is (-1)^sign_bit.  The input must satisfy Streng's two
    congruences, as every integer product of the standard F_k basis does.
    """
    u = ZZ(u) % N
    if gcd(u, N) != 1:
        raise ValueError("u must be a unit modulo N")

    m = N//2
    a = vector(ZZ, a)
    if len(a) != m:
        raise ValueError("wrong number of Siegel exponents")

    A0 = sum(a)
    A2 = sum(k*k*a[k-1] for k in range(1, m+1))
    if A0 % 12 or A2 % (N*gcd(N, 2)):
        raise ValueError("the H-exponents do not define a Q-rational modular unit")

    b = zero_vector(ZZ, m)
    parity = u*(A2//N)
    for k in range(1, m+1):
        q, r = divmod(u*k, N)
        j = can(r, N)
        b[j-1] += a[k-1]
        parity += (k + q)*a[k-1]

    return b, ZZ(parity % 2)


def chi_from_exponents(N, u, e):
    r"""Compute chi_f(<u>) directly from F-exponents.

    Here f = F_2^e[0] * ... * F_(floor(N/2)+1)^e[-1].
    chi_f(<u>) is defined only when div(f) is fixed by <u>; otherwise g^*f/f
    is nonconstant and this function raises ValueError.
    """
    e = vector(ZZ, e)
    A = F_to_H_matrix(N)
    if len(e) != A.nrows():
        raise ValueError("wrong number of F-exponents")

    a = e*A
    b, bit = siegel_diamond_action(N, u, a)
    if b != a:
        raise ValueError("div(f) is not fixed by this diamond operator")
    return ZZ(-1 if bit else 1)


def chi_on_delta(N, delta_generators, e):
    """Dictionary u -> chi_f(<u>) for every u in Delta."""
    Delta = diamond_subgroup(N, delta_generators)
    return {u: chi_from_exponents(N, u, e) for u in Delta}


# 5. The lattices L1, L2, L3 ----------------------------------------------


def _coordinates_in_rows(vectors, row_basis):
    """Coordinates of vectors in a full-row-rank integer row basis."""
    if vectors.nrows() == 0:
        return matrix(ZZ, 0, row_basis.nrows())

    # Solve row_coordinates * row_basis = vectors in one matrix solve.
    solution = row_basis.change_ring(QQ).transpose().solve_right(
        vectors.change_ring(QQ).transpose()
    ).transpose()

    if any(QQ(x).denominator() != 1 for x in solution.list()):
        raise ArithmeticError("vector is not in the integral row lattice")

    return matrix(ZZ, solution)


def _parity_kernel_lattice(S):
    r"""Z-basis of {x in Z^s : S*x = 0 mod 2}."""
    s = S.ncols()
    if s == 0:
        return matrix(ZZ, 0, 0)
    if S.nrows() == 0 or S.rank() == 0:
        return identity_matrix(ZZ, s)

    K2 = S.right_kernel().basis_matrix()
    gens = [vector(ZZ, [ZZ(x) for x in row]) for row in K2.rows()]
    gens += [2*identity_matrix(ZZ, s).row(i) for i in range(s)]
    return matrix(ZZ, gens).row_module(ZZ).basis_matrix()


def modular_unit_lattices(N, delta_generators, verbose=False):
    r"""Compute L1, L2, and L3 for X_1(N) -> X_Delta(N).

    L1: all Q-rational modular-unit divisors on X_1(N).
    L2: those divisors which are pullbacks of integral cusp divisors downstairs.
    L3: actual pullbacks of modular units downstairs, i.e. ker(chi : L2 -> {+-1}^Delta).

    Exponent rows always use the order F_2,...,F_(floor(N/2)+1).
    """
    prefix = "MU N=%s lattices" % N
    total = time.perf_counter()

    t0 = time.perf_counter()
    Delta = diamond_subgroup(N, delta_generators)
    U = modular_unit_matrix(N)
    B, fibers = pullback_cusp_matrix(N, Delta)
    _log(verbose, prefix,
         "built Delta, L1 and cusp-pullback matrix in %.3fs "
         "(|Delta|=%s, L1=%sx%s, downstairs cusps=%s)"
         % (time.perf_counter()-t0, len(Delta), U.nrows(), U.ncols(), B.nrows()))

    # L2 = rowspan(U) intersection rowspan(B).
    t0 = time.perf_counter()
    I = U.row_module(ZZ).intersection(B.row_module(ZZ))
    D2 = I.basis_matrix()
    _log(verbose, prefix,
         "computed L2 lattice intersection in %.3fs (rank=%s)"
         % (time.perf_counter()-t0, D2.nrows()))

    t0 = time.perf_counter()
    E2 = _coordinates_in_rows(D2, U)
    Q2 = _coordinates_in_rows(D2, B)
    _log(verbose, prefix,
         "computed L2 coordinates in %.3fs" % (time.perf_counter()-t0))

    # It is enough to test chi on the supplied subgroup generators.
    char_elements = sorted({
        can(u, N) for u in delta_generators
        if can(u, N) != can(1, N)
    })

    t0 = time.perf_counter()
    FH = F_to_H_matrix(N)
    H2 = E2 * FH
    char_rows = []
    for u in char_elements:
        row = []
        for a in H2.rows():
            b, bit = siegel_diamond_action(N, u, a)
            if b != a:
                raise ArithmeticError(
                    "an L2 divisor is unexpectedly not invariant under <%s>" % u
                )
            row.append(bit)
        char_rows.append(row)

    S = (matrix(GF(2), char_rows) if char_rows
         else matrix(GF(2), 0, E2.nrows()))

    C = _parity_kernel_lattice(S)
    E3 = C*E2
    D3 = C*D2
    Q3 = C*Q2
    _log(verbose, prefix,
         "computed chi-kernel L3 in %.3fs (rank=%s, sign rank=%s)"
         % (time.perf_counter()-t0, Q3.nrows(), S.rank()))

    _log(verbose, prefix,
         "all lattice stages finished in %.3fs" % (time.perf_counter()-total))

    return {
        "Delta": Delta,
        "fibers": fibers,

        "L1_divisor_basis": U,

        "L2_divisor_basis": D2,
        "L2_unit_exponents": E2,
        "L2_downstairs_divisors": Q2,

        "character_elements": char_elements,
        "character_matrix": S,                 # columns correspond to L2 basis rows

        "L3_divisor_basis": D3,
        "L3_unit_exponents": E3,
        "L3_downstairs_divisors": Q3,

        # Backward-compatible names from the first version of this file.
        "unit_divisors": U,
        "pullback_cusp_divisors": B,
        "pulled_back_divisors": D2,
        "unit_exponents": E2,
        "downstairs_divisors": Q2,
    }


# Optional theory check: no models or q-expansion truncation are used.


def _B2(x):
    x = QQ(x) - floor(QQ(x))
    return x*x - x + QQ(1)/6


def divisor_from_H_exponents(N, a):
    """Cusp divisor of product H_k^a_k from the Bernoulli formula."""
    m = N//2
    a = vector(ZZ, a)
    ans = []
    for c in range(m+1):
        v = inverse_gcd(c, N) * sum(
            QQ(a[k-1])/2 * _B2(QQ(c*k)/N) for k in range(1, m+1)
        )
        ans.append(ZZ(v))
    return vector(ZZ, ans)


def check_formulas(N):
    """Sanity-check the F/H conversion and every diamond divisor permutation."""
    FH = F_to_H_matrix(N)
    U = modular_unit_matrix(N)
    assert matrix(ZZ, [divisor_from_H_exponents(N, a) for a in FH.rows()]) == U

    for u in range(1, N):
        if gcd(u, N) != 1:
            continue
        for a, v in zip(FH.rows(), U.rows()):
            b, _ = siegel_diamond_action(N, u, a)
            expected = vector(ZZ, [v[can(u*i, N)] for i in range(N//2+1)])
            assert divisor_from_H_exponents(N, b) == expected
    return True


# 6. Degrees and output formatting ----------------------------------------


def downstairs_cusp_degrees(N, Delta):
    r"""Degrees over Q of the closed cusps on X_Delta(N).

    If B_j = pi^*(Q_j), then deg(B_j) = |Delta| * deg(Q_j).
    """
    B, _ = pullback_cusp_matrix(N, Delta)
    degrees_X1 = vector(ZZ, [degree_cusp(i, N) for i in range(N//2 + 1)])

    d = ZZ(len(Delta))
    answer = []
    for pullback in B.rows():
        numerator = pullback.dot_product(degrees_X1)
        if numerator % d != 0:
            raise ArithmeticError("nonintegral downstairs cusp degree")
        answer.append(numerator // d)

    return vector(ZZ, answer)


def positive_degree(divisor, cusp_degrees):
    """Degree of the positive part of a degree-zero cusp divisor."""
    return ZZ(sum(
        cusp_degrees[i] * max(ZZ(divisor[i]), 0)
        for i in range(len(divisor))
    ))


def F_monomial_string(exponents):
    """Pretty-print product F_2^e_2 ... F_(m+1)^e_(m+1)."""
    numerator = []
    denominator = []

    for k, exponent in enumerate(exponents, start=2):
        exponent = ZZ(exponent)
        if exponent > 0:
            numerator.append(
                "F_%s" % k if exponent == 1 else "F_%s^%s" % (k, exponent)
            )
        elif exponent < 0:
            exponent = -exponent
            denominator.append(
                "F_%s" % k if exponent == 1 else "F_%s^%s" % (k, exponent)
            )

    num = " * ".join(numerator) if numerator else "1"
    if not denominator:
        return num
    return "%s / (%s)" % (num, " * ".join(denominator))


# 7. Fast exact minimum-degree search -------------------------------------


def _effective_cusp_divisors(cusp_degrees, degree):
    r"""Yield all effective cusp divisors of weighted degree `degree`.

    The output consists of Python tuples, for cheap hashing and storage.
    A suffix-gcd test prunes branches that cannot reach the target degree.
    """
    weights = [int(x) for x in cusp_degrees]
    degree = int(degree)
    n = len(weights)

    # Put larger weights first: this generally makes the recursion shallower.
    order = sorted(range(n), key=lambda i: (-weights[i], i))
    coeffs = [0] * n

    suffix_gcd = [0] * (n + 1)
    for pos in range(n-1, -1, -1):
        suffix_gcd[pos] = int(gcd(suffix_gcd[pos+1], weights[order[pos]]))

    def recurse(pos, remaining):
        if remaining < 0:
            return
        if pos == n:
            if remaining == 0:
                yield tuple(coeffs)
            return
        if remaining % suffix_gcd[pos] != 0:
            return

        i = order[pos]
        w = weights[i]

        if pos == n-1:
            if remaining % w == 0:
                coeffs[i] = remaining // w
                yield tuple(coeffs)
                coeffs[i] = 0
            return

        for multiplicity in range(remaining // w + 1):
            coeffs[i] = multiplicity
            for answer in recurse(pos+1, remaining - multiplicity*w):
                yield answer
        coeffs[i] = 0

    for answer in recurse(0, degree):
        yield answer


def _smith_class_data(Q):
    r"""Precompute a canonical key for Z^s / rowspan(Q).

    Let A=Q^T.  If D=U*A*V is Smith normal form, then x and y have the same
    class modulo rowspan(Q) iff U*x and U*y agree modulo the nonzero diagonal
    entries of D, and agree exactly in the remaining free coordinates.
    """
    if Q.rank() != Q.nrows():
        raise ArithmeticError("Q must have independent rows")

    A = Q.transpose()
    D, U, V = A.smith_form()
    rank = Q.nrows()
    ambient_rank = Q.ncols()

    diagonal = [abs(int(D[i, i])) for i in range(rank)]
    if any(d == 0 for d in diagonal):
        raise ArithmeticError("unexpected zero Smith invariant")

    U_rows = [tuple(int(x) for x in U.row(i)) for i in range(ambient_rank)]

    return {
        "rank": rank,
        "ambient_rank": ambient_rank,
        "diagonal": tuple(diagonal),
        "U_rows": tuple(U_rows),
    }


def _smith_class_key(v, data):
    """Canonical hashable class of v modulo the lattice used in data."""
    y = []
    for row in data["U_rows"]:
        y.append(sum(row[j] * v[j] for j in range(data["ambient_rank"])))

    rank = data["rank"]
    diagonal = data["diagonal"]
    return tuple(
        y[i] % diagonal[i] if i < rank else y[i]
        for i in range(data["ambient_rank"])
    )


def _minimum_known_degree_from_basis(Q, cusp_degrees):
    """A guaranteed upper bound, improved cheaply by Euclidean LLL."""
    rows = list(Q.rows())
    try:
        rows += list(Q.LLL().rows())
    except Exception:
        # The original basis still gives a valid upper bound.
        pass

    degrees = [positive_degree(v, cusp_degrees) for v in rows if v != 0]
    if not degrees:
        raise ValueError("the modular-unit lattice is zero")
    return min(degrees)


def _find_minimum_downstairs_divisor(
        Q, cusp_degrees, diagnostics=True, max_degree=None,
        progress_interval=100000, prefix="MU search"):
    r"""Find a shortest nonzero divisor in Q for the weighted l1 degree.

    At degree d, enumerate all effective cusp divisors A of degree d.  If two
    distinct A,B have the same class modulo rowspan(Q), then A-B is a principal
    cusp divisor in Q.  The first degree at which this happens is exactly the
    minimum modular-unit degree.
    """
    t0 = time.perf_counter()
    class_data = _smith_class_data(Q)
    _log(diagnostics, prefix,
         "Smith class map computed in %.3fs; invariants=%s"
         % (time.perf_counter()-t0, list(class_data["diagonal"])))

    zero = tuple(0 for _ in range(Q.ncols()))
    zero_key = _smith_class_key(zero, class_data)
    for row in Q.rows():
        if _smith_class_key(tuple(int(x) for x in row), class_data) != zero_key:
            raise ArithmeticError("Smith class map failed a lattice-row check")

    upper_bound = _minimum_known_degree_from_basis(Q, cusp_degrees)
    if max_degree is None:
        search_limit = upper_bound
    else:
        search_limit = min(ZZ(max_degree), upper_bound)

    weights = [ZZ(x) for x in cusp_degrees]
    degree_step = ZZ(gcd(weights))
    degree = ZZ(min(weights))

    _log(diagnostics, prefix,
         "searching exact degrees %s,%s,...,%s; guaranteed basis upper bound=%s"
         % (degree, degree+degree_step, search_limit, upper_bound))

    while degree <= search_limit:
        degree_start = time.perf_counter()
        seen = {}
        count = 0

        _log(diagnostics, prefix, "degree %s: enumeration started" % degree)

        for effective in _effective_cusp_divisors(weights, degree):
            count += 1
            key = _smith_class_key(effective, class_data)

            previous = seen.get(key)
            if previous is not None:
                difference = vector(ZZ, [
                    effective[i] - previous[i] for i in range(len(effective))
                ])
                if difference == 0:
                    continue

                actual_degree = positive_degree(difference, cusp_degrees)
                if actual_degree != degree:
                    raise ArithmeticError(
                        "collision at search degree %s reduces to degree %s; "
                        "this indicates an enumeration or class-map error"
                        % (degree, actual_degree)
                    )

                coordinates = _coordinates_in_rows(
                    matrix(ZZ, [difference]), Q
                ).row(0)

                if coordinates * Q != difference:
                    raise ArithmeticError("failed to reconstruct collision in L3")

                elapsed = time.perf_counter() - degree_start
                _log(diagnostics, prefix,
                     "degree %s: collision after %s effective divisors (%.3fs)"
                     % (degree, count, elapsed))

                return degree, coordinates, difference, {
                    "effective_divisors_checked": count,
                    "degree_search_elapsed": elapsed,
                    "basis_upper_bound": upper_bound,
                    "zero_divisor": vector(ZZ, effective),
                    "pole_divisor": vector(ZZ, previous),
                }

            seen[key] = effective

            if diagnostics and progress_interval and count % progress_interval == 0:
                _log(True, prefix,
                     "degree %s: checked %s effective divisors in %.1fs; "
                     "stored classes=%s"
                     % (degree, count, time.perf_counter()-degree_start, len(seen)))

        _log(diagnostics, prefix,
             "degree %s: no collision among %s effective divisors (%.3fs)"
             % (degree, count, time.perf_counter()-degree_start))
        degree += degree_step

    if max_degree is not None and ZZ(max_degree) < upper_bound:
        raise ValueError(
            "no descended modular unit found through requested max_degree=%s; "
            "a basis gives the guaranteed upper bound %s"
            % (max_degree, upper_bound)
        )

    raise ArithmeticError(
        "no collision found by the guaranteed upper bound %s; "
        "please send the diagnostic output" % upper_bound
    )


def lowest_degree_modular_unit(
        N, delta_generators, solver="GLPK", diagnostics=True,
        max_degree=None, progress_interval=100000):
    r"""Return a lowest-degree nonconstant modular unit on X_Delta(N).

    Its degree is a rigorous upper bound on the Q-gonality of X_Delta(N).
    The `solver` parameter is kept for API compatibility with the notebook
    version but is unused by the exact search below.

    The F-exponents are ordered as
        F_2, F_3, ..., F_(floor(N/2)+1).
    """
    if N < 3:
        raise NotImplementedError("implemented for N >= 3")

    prefix = "MU N=%s" % N
    total_start = time.perf_counter()
    _log(diagnostics, prefix,
         "starting lowest-degree search; generators=%s" % list(delta_generators))

    t0 = time.perf_counter()
    R = modular_unit_lattices(N, delta_generators, verbose=diagnostics)
    _log(diagnostics, prefix,
         "L1/L2/L3 construction took %.3fs" % (time.perf_counter()-t0))

    Delta = R["Delta"]
    Q = R["L3_downstairs_divisors"]
    E = R["L3_unit_exponents"]
    D = R["L3_divisor_basis"]

    if Q.nrows() == 0:
        raise ValueError("there are no nonconstant modular units")
    if Q.rank() != Q.nrows():
        raise ArithmeticError("L3 divisor rows are not independent")

    cusp_degrees = downstairs_cusp_degrees(N, Delta)
    for row in Q.rows():
        if row.dot_product(cusp_degrees) != 0:
            raise ArithmeticError("L3 contains a non-degree-zero divisor")

    _log(diagnostics, prefix,
         "|Delta|=%s, L3 rank=%s, downstairs cusps=%s, cusp degrees=%s, "
         "max |L3 coefficient|=%s"
         % (len(Delta), Q.nrows(), Q.ncols(), list(cusp_degrees),
            max(abs(x) for x in Q.list())))

    degree, coordinates, downstairs_divisor, search_stats = \
        _find_minimum_downstairs_divisor(
            Q, cusp_degrees,
            diagnostics=diagnostics,
            max_degree=max_degree,
            progress_interval=progress_interval,
            prefix=prefix + " degree"
        )

    F_exponents = coordinates * E

    _log(diagnostics, prefix, "verifying the returned divisor and character")
    verify_start = time.perf_counter()

    B, fibers = pullback_cusp_matrix(N, Delta)
    U = modular_unit_matrix(N)

    upstairs_from_pullback = downstairs_divisor * B
    upstairs_from_function = F_exponents * U
    upstairs_from_L3_basis = coordinates * D

    assert upstairs_from_pullback == upstairs_from_function
    assert upstairs_from_function == upstairs_from_L3_basis

    character = chi_on_delta(N, delta_generators, F_exponents)
    assert all(value == 1 for value in character.values())

    degrees_X1 = vector(ZZ, [degree_cusp(i, N) for i in range(N//2 + 1)])
    upstairs_degree = positive_degree(upstairs_from_function, degrees_X1)

    assert upstairs_degree == len(Delta) * degree
    assert positive_degree(-downstairs_divisor, cusp_degrees) == degree

    _log(diagnostics, prefix,
         "verification finished in %.3fs; total elapsed %.3fs"
         % (time.perf_counter()-verify_start,
            time.perf_counter()-total_start))
    _log(diagnostics, prefix,
         "minimum degree=%s, function=%s"
         % (degree, F_monomial_string(F_exponents)))

    return {
        "degree": degree,
        "function": F_monomial_string(F_exponents),

        # Exponents of F_2,...,F_(floor(N/2)+1).
        "F_exponents": F_exponents,

        # Coordinates relative to the returned L3 basis.
        "L3_basis_coordinates": coordinates,

        # Coefficients at the closed cusps of X_Delta(N).
        "downstairs_divisor": downstairs_divisor,
        "downstairs_cusp_degrees": cusp_degrees,

        # Corresponding divisor on X_1(N).
        "upstairs_divisor": upstairs_from_function,
        "upstairs_degree": upstairs_degree,

        "Delta": Delta,
        "fibers": fibers,
        "character": character,

        # Additional diagnostic information about the exact search.
        "search_statistics": search_stats,
    }
