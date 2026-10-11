// Reusable exact closed-place construction for singular plane models.
//
// A closed point is often most naturally specified by polynomial relations
// among function-field generators.  Those generators need not lie in
// MaximalOrderFinite(F), so the resulting fractional ideal has a denominator.
// Clearing it introduces denominator content.  Cancelling the common
// denominator component once gives the correct prime ideal in the intended
// use cases; primality is then mandatory.  Repeated cancellation is unsafe
// because the desired branch may itself lie above the denominator.

function SaturatedOrderIdeal(O,generators)
    fractional_ideal := ideal<O | generators>;
    denominator := Denominator(fractional_ideal);
    integral_ideal := denominator*fractional_ideal;
    denominator_ideal := ideal<O | denominator>;
    denominator_part := GCD(integral_ideal,denominator_ideal);
    saturated_ideal := integral_ideal/denominator_part;
    return saturated_ideal,denominator;
end function;

function ClosedPlaceFromRelations(O,generators : ExpectedDegree := 0)
    prime_ideal,denominator := SaturatedOrderIdeal(O,generators);
    if not IsPrime(prime_ideal) then
        error "the saturated relations do not define one closed place";
    end if;
    P := Place(prime_ideal);
    if ExpectedDegree ne 0 and Degree(P) ne ExpectedDegree then
        error "closed place has unexpected degree";
    end if;
    return P,prime_ideal,denominator;
end function;
