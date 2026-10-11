# A quintic function at level 64

For Delta=<-1,9> modulo 64, the new canonical curve has genus five and
equations

    x1*x3 - x2^2 - x3*x5 = 0,
    x1*x4 - x3^2 - 3*x4*x5 = 0,
    x1*x5 - x4^2 - 2*x5^2 = 0.

Take P=(3:0:0:1:1) and the quadratic closed point Q whose conjugates are

    (2a+3 : 2a : a+1 : a : 1),  a^2-2a-1=0.

These coordinates satisfy all three equations directly. The polynomial
is irreducible over Q, so Q is a rational effective divisor of degree two.
Put E=P+Q and D=K-E. Then deg(D)=5. The exact Riemann--Roch calculation in
`case64_quintic.m` verifies h0(D)=2, and the ratio of its basis sections
has pole divisor of degree exactly five. This also verifies that the
pencil has no base point. Hilbert irreducibility gives infinitely many
closed points of degree exactly five over Q.

The model's modular identification is the existing independent
q-expansion/Hilbert-polynomial certificate. No assertion about rational
torsion is needed for this positive result.

The quadratic point was found by constructing the j-map afresh on the
canonical model and recovering its entire pole support. This uncovered
the Q(sqrt(2)) cusp missing from the earlier bounded support searches.
That discovery computation is useful machinery, but is deliberately not
a dependency of the short final witness: the displayed coordinates and
the exact degree check suffice.
