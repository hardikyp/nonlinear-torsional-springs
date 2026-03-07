# Nonlinear torsional springs

This codebase implements nonlinear behavior into the three-node torsional spring (3NTS) developed in Patil and Filipov (2026).
> Patil, H. Y., and Filipov, E. T. (2026). "Three-Node Torsional Spring Element Formulation for the Analysis of Reconfigurable Bar-Linked Structures." ASME. J. Appl. Mech. March 2026; 93(3): 034502. [https://doi.org/10.1115/1.4070821](https://doi.org/10.1115/1.4070821)

## Spring constitutive law for clamped spring behavior

Let

- $\alpha \in [0,2\pi)$ — current spring angle  
- $\alpha_0$ — reference (rest) angle  
- $\alpha_1, \alpha_2$ — transition angles  
- $K_T$ — baseline stiffness  
- $\delta$ — inward shift of asymptotes  

with the admissible range $0 \le \delta < \alpha_1 < \alpha_2 < 2\pi-\delta$. If $\delta > 0$, the angle is clamped to $\alpha \in (\delta,\,2\pi-\delta)$

### Strain Energy

The strain energy $U(\alpha)$ satisfying $M=\frac{dU}{d\alpha}$ is

$$
U(\alpha)=
\begin{cases}

\frac12 K_T(\alpha_0-\alpha_1)^2
+ K_T(\alpha_0-\alpha_1)(\alpha_1-\alpha)
- \frac{4K_T(\alpha_1-\delta)^2}{\pi^2}
\ln\!\left|\cos\!\left(\frac{\pi(\alpha_1-\alpha)}{2(\alpha_1-\delta)}\right)\right|,

& \alpha < \alpha_1

\\[24pt]

\frac12 K_T(\alpha-\alpha_0)^2,

& \alpha_1 \le \alpha \le \alpha_2

\\[24pt]

\frac12 K_T(\alpha_2-\alpha_0)^2
+ K_T(\alpha_2-\alpha_0)(\alpha-\alpha_2)
- \frac{4K_T((2\pi-\delta)-\alpha_2)^2}{\pi^2}
\ln\!\left|\cos\!\left(\frac{\pi(\alpha-\alpha_2)}{2((2\pi-\delta)-\alpha_2)}\right)\right|,

& \alpha > \alpha_2

\end{cases}
$$

### Moment

The torsional moment $M(\alpha)$ is
$$
M(\alpha)=
\begin{cases}
K_T(\alpha_1-\alpha_0) + \dfrac{2K_T(\alpha_1-\delta)}{\pi}\tan\Bigg(\frac{\pi(\alpha-\alpha_1)}{2(\alpha_1-\delta)}\Bigg),
& \alpha < \alpha_1
\\[24pt]

K_T(\alpha-\alpha_0),
& \alpha_1 \le \alpha \le \alpha_2
\\[24pt]

K_T(\alpha_2-\alpha_0) + \dfrac{2K_T((2\pi-\delta)-\alpha_2)}{\pi}\tan\Bigg(\frac{\pi(\alpha-\alpha_2)}{2((2\pi-\delta)-\alpha_2)}\Bigg),
& \alpha > \alpha_2
\end{cases}
$$

### Value of tangent stiffness

The tangent stiffness is
$$
K_T(\alpha) = \frac{dM}{d\alpha}
$$

$$
K_T(\alpha)=
\begin{cases}
K_T\,\sec^2\Bigg(\frac{\pi(\alpha-\alpha_1)}{2(\alpha_1-\delta)}\Bigg),
& \alpha < \alpha_1
\\[24pt]

K_T,
& \alpha_1 \le \alpha \le \alpha_2
\\[24pt]

K_T\,\sec^2\Bigg(\frac{\pi(\alpha-\alpha_2)}{2((2\pi-\delta)-\alpha_2)}\Bigg),
& \alpha > \alpha_2
\end{cases}
$$

### Asymptotic Behavior

The nonlinear branches introduce barrier asymptotes:

- Left barrier at $\alpha \to \delta$
- Right barrier at $\alpha \to 2\pi-\delta$

Near these limits, $\tan(\xi) \to \pm\infty$. So $M(\alpha) \to \pm\infty$ and $K_T(\alpha) \to \infty$.