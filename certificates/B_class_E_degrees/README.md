# Theorem B, class E: elliptic curves of odd analytic rank

For the 43 curves of class E (paper, §7.3 and Table 10), the argument needs, for each level $N$, the
elliptic curves of conductor $N$ with odd analytic rank and their optimal modular degrees $d_E$. A morphism
$X_\Delta(N)\to E'$, with $E'$ isogenous to such an $E$, then has degree divisible by $t\cdot d_E$, where
$t=[(\mathbb Z/N\mathbb Z)^\times:\Delta]$ (Derickx–Orlić, Corollary 4.10). This product is composite, so the degree is not 5.

`modular_degrees.m` reads these numbers from Cremona's database in Magma; the output is `modular_degrees.log`.
At levels 67 and 73 there is no such curve.

```sh
magma -b modular_degrees.m
```
