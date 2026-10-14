// Complete place enumeration over F2, using Magma throughout.
// For base primes of the target degree, only linear residual factors can
// contribute. Construct their prime ideals directly at squarefree primes.
// Exceptional primes and smaller base degrees use native decomposition.
function F2PlacesOfDegree(K, target : Shard := 0, Shards := 1)
    assert #ConstantField(K) eq 2;
    if target le 1 then return Places(K,target); end if;
    RF := BaseField(K); R := PolynomialRing(GF(2));
    f := DefiningPolynomial(K); f /:= LeadingCoefficient(f); n := Degree(f);
    A := LCM([Denominator(c):c in Coefficients(f)]);
    coeffs := [R!Numerator(Coefficient(f,i)*A^(n-i)):i in [0..n]];
    assert &and[Denominator(Coefficient(f,i)*A^(n-i)) eq 1:i in [0..n]];
    O := MaximalOrderFinite(K); z := O!(K!A*K.1);
    result := [Places(K)|];
    if Shard eq 0 then result := [P:P in InfinitePlaces(K)|Degree(P) eq target]; end if;
    for e in Divisors(target) do
        primes := e eq 1 select {R.1,R.1+1} else AllIrreduciblePolynomials(GF(2),e);
        // Sorting polynomial bit encodings makes the partition reproducible
        // across processes, independently of set iteration order.
        primes := [R!Intseq(v,2):v in Sort([SequenceToInteger([Integers()!c:c in Coefficients(h)],2):h in primes])];
        for index->h in primes do
            if e lt target then
                if Shard eq 0 then
                    result cat:= [P:P in Decomposition(K,Zeros(RF!h)[1])|Degree(P) eq target];
                end if;
                continue;
            end if;
            if (index-1) mod Shards ne Shard then continue; end if;
            k<a> := ext<GF(2)|h>; T<t> := PolynomialRing(k);
            reduced := T![Evaluate(c,a):c in coeffs];
            if Degree(GCD(reduced,Derivative(reduced))) gt 0 then
                result cat:= [P:P in Decomposition(K,Zeros(RF!h)[1])|Degree(P) eq target];
                continue;
            end if;
            for root in Roots(reduced) do
                lift := Evaluate(R!Eltseq(root[1]),RF.1);
                P := Place(ideal<O|O!(K!h),z-O!(K!lift)>);
                assert Degree(P) eq target;
                Append(~result,P);
            end for;
        end for;
    end for;
    assert #Seqset(result) eq #result;
    return result;
end function;

// Load CurveArith/src/gonality.m before this file. We reuse its expansion
// routine without changing or copying it. One maximal expansion per place
// preserves the filtration; do NOT row-compress these matrices.
function ExportF2Jets(K, bound, output : Checks := 8, Backend := "fast", Shard := 0, Shards := 1, PlaceEnumerator := 0)
    started := Realtime(); SetSeed(1);
    if Type(K) eq FldFunRat then
        T<zz> := PolynomialRing(K); K<aa> := FunctionField(zz-K.1);
    end if;
    K := RationalExtensionRepresentation(K);
    assert Characteristic(ConstantField(K)) eq 2;
    if DimensionOfExactConstantField(K) ne 1 then
        K := ConstantFieldExtension(K,ExactConstantField(K));
    end if;
    c := Degree(ConstantField(K),GF(2));
    assert Shards ge 1 and Shard ge 0 and Shard lt Shards;
    assert Shards eq 1 or c eq 1;
    if c gt 1 then Backend := "fast"; end if;
    if Type(K) eq FldFunRat then
        T<zz> := PolynomialRing(K); K<aa> := FunctionField(zz-K.1);
    end if;
    assert bound ge 1;
    g := Genus(K); ps := c eq 1 select Places(K,1) else [Places(K)|]; nr := #ps;
    printf "EXPORT_SETUP genus=%o rational=%o seconds=%o\n",g,nr,Realtime(started);
    n := (nr+2) div 3;
    maxdegree := Max(1,bound-Min(n,bound-1));
    counts := [nr];
    for e in [2..maxdegree] do
        if Shards gt 1 then pp := PlaceEnumerator(K,e:Shard:=Shard,Shards:=Shards);
        else pp := e mod c eq 0 select Places(K,e div c) else [Places(K)|]; end if;
        ps cat:= pp; Append(~counts,#pp);
        printf "EXPORT_PLACES degree=%o count=%o seconds=%o\n",e,#pp,Realtime(started);
    end for;
    assert #Seqset(ps) eq #ps;
    ws := BasisOfDifferentialsFirstKind(K); assert #ws eq g;
    if c gt 1 then
        CB := Basis(ConstantField(K),GF(2)); ws := [b*w:b in CB,w in ws];
    end if;
    columns := c*g;
    if Shards gt 1 then
        dx_basis := Differential(K!BaseField(K).1); assert not IsZero(dx_basis);
        Write(output cat ".basis",Sprint(<DefiningPolynomial(K),[Eltseq(w/dx_basis):w in ws]>,"Magma"):Overwrite:=true);
    end if;
    printf "EXPORT_BASIS seconds=%o\n",Realtime(started);
    if Backend eq "fast" and g gt 0 then
        dx := Differential(K!BaseField(K).1);
        if IsZero(dx) then Backend := "curvearith";
        else
            support,orders := Support(Divisor(dx));
            fs := [w/dx:w in ws];
            // A*alpha is integral for A clearing all denominators of the
            // monic defining polynomial. This clears power-basis denominators
            // for every f, so all conversions below certify integrality.
            defining := DefiningPolynomial(K); defining /:= LeadingCoefficient(defining);
            A := LCM([Denominator(c):c in Coefficients(defining)]);
            den := LCM([Denominator(c):c in Eltseq(f),f in fs])*A^(Degree(K)-1);
            O := MaximalOrderFinite(K); nums := [O!(K!den*f):f in fs]; den := O!(K!den);
        end if;
    end if;
    identities := [Sprintf("F2PLACES 2 %o",c),Sprint(DefiningPolynomial(K),"Magma")];
    magic := Shards eq 1 select "F2JETS" else "F2JETS_PART";
    lines := [Sprintf("%o 2 %o %o %o %o %o %o",magic,g,c,bound,nr,maxdegree,#ps),
              "COUNTS " cat Join([IntegerToString(x):x in counts]," ")];
    limits := []; blocks := [* *];
    for i->P in ps do
        e := c*Degree(P);
        m := e eq 1 select Max(2,bound-n+1) else (bound-n) div e;
        assert m ge 1;
        // Genus zero has no differentials; its jet rows are all zero.
        if g eq 0 then B := ZeroMatrix(GF(2),m*e,0);
        elif Backend eq "curvearith" then
            B := Transpose(HorizontalJoin(DifferentialExpansionMatrices(ws,P,m)));
        else
            index := Index(support,P); v := index eq 0 select 0 else orders[index];
            used := false;
            if m eq 1 and v eq 0 and IsFinite(P) then
                k,red := ResidueClassField(P); dd := red(den);
                if dd ne 0 then
                    coefficients := [[red(f)/dd:f in nums]]; used := true;
                end if;
            end if;
            if not used then
                ss := [* *];
                for f in fs do
                    z,u := Expand(f,P:AbsPrec:=Max(1,m-v));
                    assert AbsolutePrecision(z) ge m-v;
                    if #ss eq 0 then uniformizer := u; k := BaseRing(Parent(z));
                    else assert u eq uniformizer;
                    end if;
                    Append(~ss,z);
                end for;
                assert Valuation(uniformizer,P) eq 1;
                coefficients := [[k!Coefficient(z,j-v):z in ss]:j in [0..m-1]];
            end if;
            V,toVector := VectorSpace(k,GF(2)); assert Dimension(V) eq e;
            entries := [GF(2)|];
            for cs in coefficients do
                coords := [Eltseq(toVector(c)):c in cs];
                for h in [1..e] do entries cat:= [c[h]:c in coords]; end for;
            end for;
            B := Matrix(GF(2),m*e,columns,entries);
        end if;
        aa,bb := TwoGenerators(P);
        Append(~identities,Sprintf("PLACE %o %o %o",i-1,e,IsFinite(P) select 1 else 0));
        for f in [K!aa,K!bb] do
            encoded := [];
            for coeff in Eltseq(f) do
                for poly in [Numerator(coeff),Denominator(coeff)] do
                    Append(~encoded,&+[Integers()|SequenceToInteger([Integers()!v:v in Eltseq(Coefficient(poly,j),GF(2))],2)*2^(c*j):j in [0..Degree(poly)]]);
                end for;
            end for;
            Append(~identities,Join([IntegerToString(v):v in encoded]," "));
        end for;
        assert Nrows(B) eq m*e and Ncols(B) eq columns;
        Append(~limits,m); Append(~blocks,B);
        Append(~lines,Sprintf("PLACE %o %o %o",i-1,e,m));
        for row in Rows(B) do
            words := [&+[Integers()|Integers()!row[j+1]*2^(j-64*w):
                       j in [64*w..Min(columns,64*(w+1))-1]]:w in [0..(columns+63) div 64-1]];
            Append(~lines,Join([IntegerToString(v):v in words]," "));
        end for;
        if i le 3 or i mod 100 eq 0 or i eq #ps then
            printf "EXPORT_BLOCK %o/%o elapsed=%o\n",i,#ps,Realtime(started);
        end if;
    end for;
    // Independent Hess RR checks on deterministic small divisors, recorded
    // in the artifact and replayed by the C++ loader/test command.
    SetSeed(20261001);
    for trial in [1..Checks] do
        if #ps eq 0 then break; end if;
        ids := Sort(Setseq({Random(1,#ps):j in [1..Min(4,#ps)]}));
        ms := [Random(1,Min(2,limits[i])):i in ids];
        D := &+[ms[j]*Divisor(ps[i]):j->i in ids];
        B := VerticalJoin(<Submatrix(blocks[i],1,1,ms[j]*c*Degree(ps[i]),columns):j->i in ids>);
        ell := c*Dimension(D);
        assert ell eq c*Degree(D)+c-Rank(B);
        Append(~lines,Sprintf("CHECK %o %o ",#ids,ell) cat
            Join([Sprintf("%o %o",i-1,ms[j]):j->i in ids]," "));
    end for;
    Append(~lines,"END");
    Write(output cat ".places",Join(identities,"\n"):Overwrite:=true);
    Write(output,Join(lines,"\n"):Overwrite:=true);
    printf "EXPORTED genus=%o bound=%o rational=%o places=%o seconds=%o\n",
           g,bound,nr,#ps,Realtime(started);
    return ps,blocks;
end function;
