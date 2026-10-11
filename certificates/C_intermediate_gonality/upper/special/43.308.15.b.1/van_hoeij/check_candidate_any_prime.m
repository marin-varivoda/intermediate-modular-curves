// Check the reduction of D=3*C3+C4+P5 at any good prime, including primes
// where the degree-5 point splits.  The sum of the matched places is the
// reduction of the rational closed point P5.

load "extended_models/43.308.15.b.1/model.m";
require assigned p : "supply p using -b p:=<prime>";
if Type(p) eq MonStgElt then p := StringToInteger(p); end if;
require p ne 43 : "p must be a good prime";

k := GF(p);
Rk<x,y> := PolynomialRing(k,2);
A2<x,y> := AffineSpace(k,2);
C := ProjectiveClosure(Curve(A2,Rk!model));
plane_ff := FunctionField(C);
FF, phi := AlgorithmicFunctionField(plane_ff);
fx := phi(plane_ff.1);
fy := phi(plane_ff.2);
Dx := Divisor(fx);
Dy := Divisor(fy);

RT<T> := PolynomialRing(k);
f := T^5 - 8*T^4 + 23*T^3 - 27*T^2 + 9*T + 1;
g := -T^4 + 5*T^3 - 7*T^2 + T + 1;
factorization := Factorization(f);
factor_degrees := [];
for item in factorization do
    factor_degrees cat:= [Degree(item[1]) : j in [1..item[2]]];
end for;
P5_components := [];
for item in factorization do
    q := item[1];
    e := item[2];
    assert e eq 1;
    matches := [P : P in Places(FF,Degree(q)) |
        Valuation(Evaluate(q,fx),P) gt 0 and
        Valuation(fy-Evaluate(g,fx),P) gt 0];
    assert #matches eq 1;
    Append(~P5_components,matches[1]);
end for;
assert &+[Degree(P) : P in P5_components] eq 5;

C3s := [P : P in Places(FF,1) |
    Valuation(Dx,P) eq -1 and Valuation(Dy,P) eq -4];
C4s := [P : P in Places(FF,1) |
    Valuation(Dx,P) eq 2 and Valuation(Dy,P) eq 6];
assert #C3s eq 1 and #C4s eq 1;

D := 3*Divisor(C3s[1]) + Divisor(C4s[1])
    + &+[Divisor(P) : P in P5_components];
assert Degree(D) eq 9;
L := RiemannRochSpace(D);
printf "PRIME=%o|P5_FACTOR_DEGREES=%o|DEGREE=%o|H0=%o\n",
    p,factor_degrees,Degree(D),Dimension(L);
exit;
