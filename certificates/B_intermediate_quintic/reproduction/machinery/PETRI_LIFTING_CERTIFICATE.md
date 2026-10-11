# Excluding quintic pencils by lifting the known quartic families

The following criterion is implemented by `verify_petri_lifting.m`.
Acceptance additionally requires the model and rank checks performed by
`run_petri_certificate.py`; a preliminary census alone is not accepted.

## Criterion and proof

Let C/Q be a smooth projective curve with a rational point and good
reduction at p. Suppose A_1,...,A_s are explicitly verified basepoint-free
quartic line bundles on C, with h0=2 both over Q and on reduction.
Assume that every F_p-rational class in W^1_5(C_Fp):

* has h0 exactly two;
* is the class of A_i+P for some P in C(F_p);
* has Petri tangent dimension exactly one.

Then C has no function of degree exactly five over Q.

Indeed, on the smooth Picard scheme over Z_p each family A_i+C is a
translated Abel curve and is contained in the relative W^1_5. The
quartic bundles extend using their exhibited rational point divisors.
Their two-dimensional section spaces commute with reduction: h0 is two
on both fibers, and Riemann--Roch gives constant h1. Their special-fiber
basepoint-freeness also ensures relative basepoint-freeness.

The Abel map is an immersion, so the exhibited branch has completed local
ring Z_p[[t]]. At each special class, the Petri tangent bound one proves
that the entire relative W^1_5 is this branch formally. To see the
integral, not merely set-theoretic, assertion, choose g-1 defining
equations whose transverse derivatives are independent modulo p. Formal
elimination leaves Z_p[[t]]; every remaining equation vanishes because
the known Abel branch is contained in W^1_5. Thus there are neither extra
branches nor vertical or infinitesimal components at that class.

If a Q-defined quintic function existed, its pole bundle would specialize
to one of the enumerated classes. Its Q_p point is consequently on a
known formal branch A_i+P. Upper semicontinuity and h0=2 on the special
fiber imply h0=2 on this generic bundle. Its two sections therefore all
vanish at the extra point P, contradicting the basepoint-free pencil
defined by the function. Notice that this argument excludes Q-defined
quintic functions; it does not claim to analyze reduction classes over
every finite extension of F_p.

If J(C)(Q) has rank zero, Pic^5(C)(Q) is finite. An irreducible quintic
divisor with h0>1 would yield a nonconstant rational function whose pole
divisor is that entire closed point, contrary to the result just proved.
Each remaining class has at most one such divisor. Hence C has only
finitely many closed points of degree five.

## Exact computational checks

The new canonical model has already been identified by exact q-expansion
relations and equality of Hilbert polynomials. Saturation changes only
the integral relation basis, not the Q-curve or its coordinates. The
verifier checks dimension one, degree 2g-2, arithmetic genus g, reducedness,
irreducibility and normalization genus g on reduction. A rational point
also verifies geometric connectedness. Equality of generic and special
Hilbert polynomials and smoothness give a good model over Z_p.

Each quartic witness is a divisor on explicitly listed rational points.
Riemann--Roch verifies h0=2 and the ratio of the basis sections has pole
degree four. Primitive integral homogeneous coordinates reduce the points;
the same two tests are repeated on the resulting quartic divisors over F_p.

All effective degree-five classes are enumerated using every closed place
of degrees 1,...,5 and every partition of 5. Over F_p any effective
rational line bundle has a rational effective representative. At every
class with h0>=2 the verifier requires h0=2, membership in the known
quartic-plus-point classes, and

    g - rank[ H0(D) * H0(K-D) -> H0(K) ] = 1.

This is the standard Petri formula for the tangent space of W^1_5 at a
class with exactly two sections. Multiplication takes place in the exact
function field, and all products are expressed in one Riemann--Roch basis
of H0(K). Finally the entire special-class set must equal the known set.

## First completed local application

For level 36 with Delta={1,17,19,35}, genus 7, reduction at 5 gives nine
rational points. Three distinct rational quartic pencils give all 27
classes of W^1_5(F5). Every class passes the tangent test. The associated
Jacobian has a freshly certified nonzero central L-value and hence rank
zero. The full replay records hashes before the classification is updated.
