# Upper bound for `43.308.15.b.1`: a pencil of degree 9

`43.308.15.b.1` is $X_\Delta(43)$ with $\Delta=\langle -1,6\rangle$, of genus 15. Its $\mathbb Q$-gonality is 9:
the lower bound is the CurveArith run over $\mathbb F_2$ (`../../../lower/runs/43.308.15.b.1.p2.*`), and
this folder proves the upper bound.

```sh
magma -b certificate.m        # about 2 seconds; output in certificate.out
```

## What is checked

Everything happens on the MD Sage canonical model `../../../models/43.308.15.b.1.m` (78 quadrics in
$\mathbb P^{14}$), the same model as for every other curve. `points.m` gives three explicit points:

- $P_5$, a closed point of degree 5: its coordinates lie in $K=\mathbb Q(a)$, $a^5+2a^4-3a^3+3a^2-a-1=0$;
- $C_3$ and $C_4$, two rational points (cusps); for $C_3$ also the next two Taylor coefficients of a
  local parametrization.

`certificate.m` checks:

1. **The model** is a smooth canonical curve of genus 15: integral of degree 28 with Hilbert polynomial
   $28t-14$, and its reduction mod 2 is integral of geometric genus 15 with a nonsingular $\mathbb F_2$-point
   (good reduction by Adžaga et al., *Computing quadratic points on modular curves $X_0(N)$*, Lemma 2.3).
2. **The points** satisfy all 78 equations and are nonsingular; the jet at $C_3$ satisfies the equations
   to order 3 and has a nonzero tangent vector.
3. **$h^0(D)=2$** for $D=3C_3+C_4+P_5$ (degree 9). A canonical section is a linear form in
   $x_0,\dots,x_{14}$. Vanishing to order 3 at $C_3$ is three linear conditions (the coefficients of
   $t^0,t^1,t^2$ along the jet), vanishing at $C_4$ is one, and vanishing at $P_5$ is one condition over $K$,
   that is five over $\mathbb Q$. These 9 conditions have rank 8, so $h^0(K-D)=15-8=7$ and by Riemann–Roch
   $h^0(D)=9+1-15+7=2$.
4. **No base points**: removing one copy of $C_3$, the point $C_4$, or the orbit $P_5$ lowers $h^0$ to 1.
   (A base locus is defined over $\mathbb Q$, so it contains either all of $P_5$ or none of it.)

So $|D|$ is a base-point-free pencil of degree 9 over $\mathbb Q$, and $\mathrm{gon}_{\mathbb Q}\le 9$.

## Where the points come from

This is not needed to check the certificate: the points are verified directly on the model.

$P_5$ is the image of the point of degree 15 on $X_1(43)$ in Mark van Hoeij's database of low-degree places
(<https://www.math.fsu.edu/~hoeij/files/X1N/LowDegreePlaces>, the record with $N=43$, `degv = 15`).
Its image on $X_\Delta(43)$ was first computed on a plane model of $X_\Delta(43)$ in two modular units.
To move it to the MD Sage model, the holomorphic differentials of the plane model were compared with
MD Sage's cusp forms through their $q$-expansions at $\infty$ (Tate curve $E_{q^{43}}$ with the point $q$);
this gave the $15\times15$ matrix of the canonical map. The cusps $C_3$, $C_4$ and the jet at $C_3$ were
found the same way, from the Tate curve with the points $q^3$ and $q^4$. An earlier version of this
certificate worked on the plane model itself; it is in the git history.
