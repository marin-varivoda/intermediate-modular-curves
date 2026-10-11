// Search for a linear isomorphism between the MD Sage canonical model of 43.308.15.b.1 and the canonical image of
// the modular-unit plane model (model.m). Over two primes we compute all isomorphisms of the reductions, turn each
// into a matrix by matching points, combine pairs by CRT and rational reconstruction, and keep a candidate only if
// it is verified exactly over Q. The verified matrix is written to isomorphism_matrix.m for identify_model.m.
SetMemoryLimit(60 * 2^30);
SetColumns(0);
load "../../../models/43.308.15.b.1.m";                 // MD Sage model: X in P^14
XMD := X; g := 15;
load "model.m";                                       // plane model: model in Pol<X,Y>
A2<X1, Y1> := AffineSpace(Rationals(), 2);
C := Curve(A2, Evaluate(model, [X1, Y1]));
phi := CanonicalMap(C);
CI := CanonicalImage(C, phi);
eqsCI := DefiningEquations(CI);
printf "canonical image: %o quadrics\n", #eqsCI;
Integral := func< f | LCM([Denominator(c) : c in Coefficients(f)]) * f >;
eqsMD := DefiningEquations(XMD);

function AllMatrices(p)
    K := GF(p); P := ProjectiveSpace(K, g - 1); R := CoordinateRing(P);
    C1 := Curve(P, [Evaluate(ChangeRing(Integral(f), K), [R.i : i in [1..g]]) : f in eqsMD]);
    C2 := Curve(P, [Evaluate(ChangeRing(Integral(f), K), [R.i : i in [1..g]]) : f in eqsCI]);
    FF1 := FunctionField(C1); FF2 := FunctionField(C2);
    F1, m1 := AlgorithmicFunctionField(FF1); F2, m2 := AlgorithmicFunctionField(FF2);
    c1 := [m1(FF1 ! (R.i / R.1)) : i in [1..g]];
    c2 := [m2(FF2 ! (R.i / R.1)) : i in [1..g]];
    pls := [Q : Q in Places(F2, 1) | &and[Valuation(f, Q) ge 0 : f in c2]];
    isos := Isomorphisms(F1, F2);
    printf "p=%o: %o isomorphisms, %o points\n", p, #isos, #pls;
    Ms := [];
    for iso in isos do
        img := [iso(f) : f in c1];
        prs := [<[Evaluate(f, Q) : f in img], [Evaluate(f, Q) : f in c2]> : Q in pls | &and[Valuation(f, Q) ge 0 : f in img]];
        n := #prs; rows := [];
        for k -> pr in prs do
            for i in [1..g] do
                v := [K | 0 : j in [1..g*g + n]];
                for j in [1..g] do v[g*(i-1) + j] := pr[1][j]; end for;
                v[g*g + k] := -pr[2][i];
                Append(~rows, v);
            end for;
        end for;
        N := NullspaceOfTranspose(Matrix(K, rows));
        if Dimension(N) eq 1 then Append(~Ms, Eltseq(N.1)[1..g*g]); end if;
    end for;
    return Ms;
end function;

function Normalize(v, k)                      // scale so that entry k is 1
    return [x / v[k] : x in v];
end function;

ps := [101, 103];
S := [AllMatrices(p) : p in ps];
m := ps[1] * ps[2];
SM := CoordinateRing(Ambient(XMD));
for v1 in S[1], v2 in S[2] do
    // a common nonzero entry to normalize on
    ks := [k : k in [1..g*g] | v1[k] ne 0 and v2[k] ne 0];
    if #ks eq 0 then continue; end if;
    k := ks[1];
    a := Normalize(v1, k); b := Normalize(v2, k);
    ent := [CRT([Integers() ! a[i], Integers() ! b[i]], ps) : i in [1..g*g]];
    ok := true; Mq := [];
    for e in ent do
        bb, r := RationalReconstruction(e mod m, m);
        if not bb then ok := false; break; end if;
        Append(~Mq, r);
    end for;
    if not ok then continue; end if;
    MQ := Matrix(Rationals(), g, g, Mq);
    if Determinant(MQ) eq 0 then continue; end if;
    lin := [&+[MQ[i, j] * SM.j : j in [1..g]] : i in [1..g]];
    if &and[Evaluate(q, lin) in Ideal(XMD) : q in eqsCI] then
        printf "VERIFIED over Q\n";
        Write("isomorphism_matrix.m", "M := Matrix(Rationals(), 15, 15, " cat Sprint(Mq) cat ");" : Overwrite := true);
        quit;
    end if;
end for;
print "NOT FOUND with these primes"; quit;
