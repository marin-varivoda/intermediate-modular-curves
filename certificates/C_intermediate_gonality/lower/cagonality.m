// Lower bound gon_Q(X) >= gon_{F_p}(X mod p), for a prime p not dividing N at which the model
// reduces to a curve of the same genus. Caller assigns: label, p.
// The caller (a script in runs/) first loads the MD Sage canonical model ../../models/<label>.m (defines N, g, X).
// CAGonality is from CurveArith (Derickx-Terao), the submodule third_party/CurveArith at the repository root.
SetQuitOnError(true);
AttachSpec("../../../../third_party/CurveArith/CurveArith.spec");
assert N mod p ne 0;
Cp := Curve(Reduction(X, p));
assert Genus(Cp) eq g;                       // good reduction of the canonical model at p
T := Realtime();
gam := CAGonality(Cp);
printf "LOWER_BOUND %o p=%o gon_Fp=%o seconds=%.1o\n", label, p, gam, Realtime(T);
quit;
