// Match the descended van Hoeij degree-5 point to Magma's finite-field places
// and test the seven recurring degree-4 cuspidal parts.
//
// Usage:
//   magma -b p:=3 gonality_43_308_15_b_1/van_hoeij/match_descended_place.m

load "extended_models/43.308.15.b.1/model.m";

require assigned p : "supply p using -b p:=<prime>";
if Type(p) eq MonStgElt then p := StringToInteger(p); end if;
require p in [2,3,5] : "this run is configured for p=2, 3, or 5";

k := GF(p);
Rk<x,y> := PolynomialRing(k,2);
A2<x,y> := AffineSpace(k,2);
C := ProjectiveClosure(Curve(A2,Rk!model));
plane_ff := FunctionField(C);
FF, to_algorithmic := AlgorithmicFunctionField(plane_ff);
fx := to_algorithmic(plane_ff.1);
fy := to_algorithmic(plane_ff.2);
Dx := Divisor(fx);
Dy := Divisor(fy);

RT<T> := PolynomialRing(k);
van_hoeij_X_polynomial :=
    T^5 - 8*T^4 + 23*T^3 - 27*T^2 + 9*T + 1;
van_hoeij_Y_from_X := -T^4 + 5*T^3 - 7*T^2 + T + 1;

degree_five_places := Places(FF,5);
matches := [];
for index -> place in degree_five_places do
    x_value := Evaluate(fx,place);
    y_value := Evaluate(fy,place);
    if Evaluate(van_hoeij_X_polynomial,x_value) eq 0 and
       y_value eq Evaluate(van_hoeij_Y_from_X,x_value) then
        Append(~matches,<index,place>);
    end if;
end for;
assert #matches eq 1;
candidate_index := matches[1][1];
candidate_place := matches[1][2];

// Match rational-place numbering to stable cusp_1,...,cusp_7 IDs.
cusp_X_valuations := [4,-5,-1,2,-3,-2,-2];
cusp_Y_valuations := [1,1,-4,6,-4,2,-2];
rational_places := Places(FF,1);
cusp_places := [];
for cusp_id in [1..7] do
    cusp_matches := [
        place : place in rational_places |
        Valuation(Dx,place) eq cusp_X_valuations[cusp_id] and
        Valuation(Dy,place) eq cusp_Y_valuations[cusp_id]
    ];
    assert #cusp_matches eq 1;
    Append(~cusp_places,cusp_matches[1]);
end for;

// These are exactly the seven degree-4 cusp patterns recurring at p=3 and 5.
cusp_multiplicities := [
    [0,0,3,1,0,0,0], // 3*cusp_3 + cusp_4
    [0,2,0,0,2,0,0], // 2*cusp_2 + 2*cusp_5
    [0,3,0,0,0,0,1], // 3*cusp_2 + cusp_7
    [0,0,1,0,3,0,0], // cusp_3 + 3*cusp_5
    [0,2,2,0,0,0,0], // 2*cusp_2 + 2*cusp_3
    [3,0,0,0,1,0,0], // 3*cusp_1 + cusp_5
    [0,1,0,0,0,3,0]  // cusp_2 + 3*cusp_6
];

printf "PRIME=%o|DESCENDED_DEGREE5_PLACE_INDEX=%o\n",p,candidate_index;
for pattern_index -> multiplicities in cusp_multiplicities do
    cusp_divisor := &+[
        multiplicities[i]*Divisor(cusp_places[i]) : i in [1..7]
    ];
    divisor := cusp_divisor + Divisor(candidate_place);
    h0 := Dimension(RiemannRochSpace(divisor));
    printf "CUSP_PATTERN=%o|H0=%o\n",pattern_index,h0;
end for;

exit;
