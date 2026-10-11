// Direct characteristic-zero verification using a Magma Place and
// RiemannRochSpace.  This deliberately favors a short, human-readable
// workflow over the faster differential-evaluation certificate.
//
// Run from the repository root:
//   magma -b gonality_43_308_15_b_1/van_hoeij/place_riemann_roch_char0.m

SetSeed(2829824311);
total_start := Realtime();

load "gonality_43_308_15_b_1/model.m";
load "extended_models/place_tools.m";

A2<Xaff,Yaff> := AffineSpace(Rationals(),2);
C := Curve(A2,Evaluate(model,[Xaff,Yaff]));
Fplane<xplane,yplane> := FunctionField(C);
F, phi := AlgorithmicFunctionField(Fplane);
x := phi(xplane);
y := phi(yplane);
assert Genus(F) eq 15;

O := MaximalOrderFinite(F);
printf "PROGRESS|STAGE=maximal_order|SECONDS=%.3o\n", Realtime(total_start);

// The descended degree-5 point is cut out by f(x)=0 and y=g(x).
Qt<t> := PolynomialRing(Rationals());
f := t^5 + 2*t^4 - 3*t^3 + 3*t^2 - t - 1;
g := (-2*t^4 - t^3 + 11*t^2 - 19*t + 13)/7;
P5, P5_ideal, P5_denominator := ClosedPlaceFromRelations(
    O, [Evaluate(f,x), y-Evaluate(g,x)] : ExpectedDegree := 5
);
assert Degree(P5) eq 5;
printf "PROGRESS|STAGE=P5_place|DEGREE=%o|SECONDS=%.3o\n",
    Degree(P5), Realtime(total_start);

// Locate the two rational cusps by their modular-unit valuations.
c3_ideal, c3_denominator := SaturatedOrderIdeal(O,[y,1/x]);
c3_places := [Place(item[1]) : item in Factorization(c3_ideal)];
C3s := [P : P in c3_places |
    Degree(P) eq 1 and Valuation(x,P) eq -4 and Valuation(y,P) eq 1];
C4s := [P : P in InfinitePlaces(F) |
    Degree(P) eq 1 and Valuation(x,P) eq 6 and Valuation(y,P) eq -4];
assert #C3s eq 1 and #C4s eq 1;
C3 := C3s[1];
C4 := C4s[1];
printf "PROGRESS|STAGE=cusps|SECONDS=%.3o\n", Realtime(total_start);

D := 3*Divisor(C3) + Divisor(C4) + Divisor(P5);
assert Degree(D) eq 9;
printf "PROGRESS|STAGE=riemann_roch_started|DEGREE=%o|SECONDS=%.3o\n",
    Degree(D), Realtime(total_start);

L, map_to_F := RiemannRochSpace(D);
printf "RESULT|DEGREE=%o|H0=%o|SECONDS=%.3o\n",
    Degree(D), Dimension(L), Realtime(total_start);
assert Dimension(L) eq 2;
print "PLACE_RIEMANN_ROCH_CERTIFIED=true";

exit;
