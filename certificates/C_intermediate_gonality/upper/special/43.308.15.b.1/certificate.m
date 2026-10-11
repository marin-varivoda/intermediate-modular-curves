// Streamlined characteristic-zero certificate for the degree-9 pencil.
//
// For D=3*C3+C4+P5, compute H^0(K-D) as exact linear conditions on the
// 15-dimensional holomorphic differential space.  Cusp conditions use local
// completions.  The P5 condition is evaluated directly in its degree-5
// number field, avoiding expensive construction of P5 as a function-field
// prime ideal.

SetSeed(2829824311);
total_start := Realtime();
load "model.m";
load "place_tools.m";

Qt<t> := PolynomialRing(Rationals());
fX := t^5 + 2*t^4 - 3*t^3 + 3*t^2 - t - 1;
assert IsIrreducible(fX);
K<a> := NumberField(fX);
yvalue := (-2*a^4 - a^3 + 11*a^2 - 19*a + 13)/7;
assert Evaluate(model,[a,yvalue]) eq 0;
// The projection to the Y-line is etale at P5, so dY is a local generator.
assert Evaluate(Derivative(model,1),[a,yvalue]) ne 0;
print "P5_ETALENESS_VERIFIED=true";

A2<Xaff,Yaff> := AffineSpace(Rationals(),2);
C := Curve(A2,Evaluate(model,[Xaff,Yaff]));
Fplane<xplane,yplane> := FunctionField(C);
F, phi := AlgorithmicFunctionField(Fplane);
x := phi(xplane);
y := phi(yplane);
assert x eq F.1;
assert y eq F!BaseField(F).1;

O := MaximalOrderFinite(F);
c3_saturated_ideal,c3_denominator :=
    SaturatedOrderIdeal(O,[y,1/x]);
c3_factors := Factorization(c3_saturated_ideal);
c3_places := [Place(item[1]) : item in c3_factors];
C3s := [P : P in c3_places |
    Degree(P) eq 1 and Valuation(x,P) eq -4 and Valuation(y,P) eq 1];
C4s := [P : P in InfinitePlaces(F) |
    Degree(P) eq 1 and Valuation(x,P) eq 6 and Valuation(y,P) eq -4];
assert #C3s eq 1 and #C4s eq 1;
printf "PROGRESS|STAGE=cusps_finished|TOTAL_SECONDS=%.3o\n",
    Realtime(total_start);

W, to_diff := SpaceOfHolomorphicDifferentials(F);
assert Dimension(W) eq 15 and Genus(F) eq 15;
omegas := [to_diff(W.i) : i in [1..15]];
dy := Differential(y);
ratios := [omega/dy : omega in omegas];
printf "PROGRESS|STAGE=holomorphic_space_finished|TOTAL_SECONDS=%.3o\n",
    Realtime(total_start);

condition_rows := [];

// ord_C3(dY)=0: kill t^0,t^1,t^2.
S3,m3 := Completion(F,C3s[1] : Precision := 5);
E3 := [m3(ratio) : ratio in ratios];
condition_rows cat:= [
    [Rationals()!Coefficient(E3[j],exponent) : j in [1..15]]
    : exponent in [0..2]
];
assert Rank(Matrix(Rationals(),condition_rows)) eq 3;
printf "LOCAL_CONDITION|NAME=C3|RANK=3|TOTAL_SECONDS=%.3o\n",
    Realtime(total_start);

// ord_C4(dY)=-5: holomorphicity already kills t^0,...,t^4, and
// ord_C4(omega)>=1 additionally kills t^5.
S4,m4 := Completion(F,C4s[1] : Precision := 8);
E4 := [m4(ratio) : ratio in ratios];
condition_rows cat:= [
    [Rationals()!Coefficient(E4[j],exponent) : j in [1..15]]
    : exponent in [0..5]
];
assert Rank(Matrix(Rationals(),condition_rows)) eq 4;
printf "LOCAL_CONDITION|NAME=C4|CUMULATIVE_RANK=4|TOTAL_SECONDS=%.3o\n",
    Realtime(total_start);

// P5 is unramified over the Y-line, so dY is a local generator of the
// canonical sheaf there.  Evaluate each ratio exactly at (a,yvalue).
function EvaluateAtP5(ratio)
    coefficients := Eltseq(ratio);
    value := K!0;
    for i in [1..#coefficients] do
        coefficient := coefficients[i];
        numerator := Numerator(coefficient);
        denominator := Denominator(coefficient);
        specialized := Evaluate(numerator,yvalue)/Evaluate(denominator,yvalue);
        value +:= specialized*a^(i-1);
    end for;
    return value;
end function;

P5_values := [EvaluateAtP5(ratio) : ratio in ratios];
for coordinate in [1..5] do
    Append(~condition_rows,[
        Rationals()!Eltseq(P5_values[j])[coordinate] : j in [1..15]
    ]);
end for;

M := Matrix(Rationals(),condition_rows);
printf "VANISHING_MATRIX_ROWS=%o\n",NumberOfRows(M);
printf "VANISHING_MATRIX_RANK=%o\n",Rank(M);
assert Rank(M) eq 8;

// deg(D)=3+1+5=9 and g=15.  Thus RR gives
// h^0(D)=h^0(K-D)+9+1-15=(15-rank(M))-5=2.
print "K_MINUS_D_H0=7";
print "DEGREE9_DIVISOR_H0=2";
print "RATIONAL_DEGREE9_PENCIL_VERIFIED=true";
printf "TOTAL_SECONDS=%.3o\n",Realtime(total_start);
exit;
