# Chapter 3: Interpolation

## 3. Introduction

For the given values of function $f(x)$ at points $x_{0}, x_{1}, \cdots, x_{n}$ the process of finding approximate values of the function $f(x)$ for new $x$'s between $x_{0}$ and $x_{n}$ is called interpolation.

Consider the points $(x_{0}, f_{0}), (x_{1}, f_{1}), \cdots, (x_{n}, f_{n})$. We find a polynomial $p_n(x)$ of degree $n$ or less than assumes the values $p_n({x_0}) = f_{0},\quad p_n({x_1}) = f_{1} \quad, \cdots, \quad p_n({x_n}) = f_{n}$.

The polynomial $p_{n}(x)$ is called the interpolation polynomial and the points $x_{0}, x_{1}, \cdots, x_{n}$ are called the nodes.

#### 3.1 Uniqueness of Interpolation Polynomial
Weierstrass Approximation Theorem states: for any continuous function $f(x)$ in an interval $a \le x \le b$ and error $\epsilon > 0$ there is a polynomial $p_n(x)$ of sufficiently higher degree $n$ such that $|f(x)-p_{n}(x)| < \epsilon$ for all $x$ in $[a, b]$.

The interpolation polynomial that satisfies $p_n({x_0}) = f_{0},\quad p_n({x_1}) = f_{1} \quad, \cdots, \quad p_n({x_n}) = f_{n}$ is unique.

### 3.2 Interpolation with Unequally Spaced Intervals

#### 3.2.1 Lagrange's Interpolation
Consider a set of $(n+1)$ arbitrary spaced data points $(x_{0}, f_{0}), (x_{1}, f_{1}), \cdots, (x_{n}, f_{n})$. Then lagrange interpolation polynomial is given by, 

$$
p_{n}(x) = \sum_{i=0}^{n} f_i L_{i}(x)
$$

where, 

$$
L_{i}(x) = \prod_{j=0, j \ne i }^{n} \dfrac{x-x_{i}}{x_{i}-x_{j}}
$$

#### 3.2.2 Newton's Divided Difference Method
Consider a set of $(n+1)$ arbitrary spaced data points $(x_{0}, f_{0}), (x_{1}, f_{1}), \cdots, (x_{n}, f_{n})$. Let: 

$$
\begin{align*}
p_{n}(x) &= a_{0} + a_{1}(x-x_{0}) + a_{2}(x-x_{0})(x-x_{1}) + \cdots \\
& + a_{n}(x-x_{0})(x-x_{1}) \cdots (x-x_{n-1})
\end{align*}
$$

be the polynomial that interpolates the above points. Then: 

$$
p_n({x_0}) = f_{0},\quad p_n({x_1}) = f_{1} \quad, \cdots, \quad p_n({x_n}) = f_{n}
$$

At point $x_{0}$,

$$
\begin{align*}
p_{n}(x_{0}) &= a_{0} \\
f_{0} &= a_{0} \\
f[x_{0}] &= a_{0}
\end{align*}
$$

Next point $x_{1}$,

$$
\begin{align*}
p_{n}(x_{1}) &= a_{0} + a_{1}(x_{1} - x_{0})\\
f_{1} &= f[x_{1}] + a_{1} (x_{1}-x_{0}) \\
a_{1} &= \frac{f[x_{1}]- f[x_{0}]}{x_{1}-x_{0}}
\end{align*}
$$

Next point $x_{2}$,

$$
\begin{align*}
p_{n}(x_{1}) &= a_{0} + a_{1}(x_{1} - x_{0}) + a_{2}(x-x_{0})(x-x_{1}) \\
a_{2} &= \frac{\frac{f[x_{2}]- f[x_{1}]}{x_{2}-x_{1}}- \frac{f[x_{1}]- f        [x_{0}]}{x_{1}-x_{0}}}{x_{2}-x_{0}} \\
     &= \frac{f[x_{1}, x_{2}] - f[x_{0}, x_{1}]}{x_{2}-x_{0}} \\
     &= f[x_{0}, x_{1}, x_{2}]
\end{align*}
$$

Similarly, 

$$
a_{n} = f[x_{0}, x_{1}, x_{2}, \dots, x_{n}]
$$

Substituting the values of $a_0, a_1, a_2, \cdots, a_n$ in the polynomial, we get Newton's divided difference interpolation polynomial:

$$
\begin{align*}
p_{n}(x) &= f[x_{0}] + f[x_{0}, x_{1}](x-x_{0}) + f[x_{0}, x_{1}, x_{2}]  (x-x_{0})(x-x_{1}) + \cdots \\
            &+ f[x_{0}, x_{1}, x_{2}, \cdots, x_{n}](x-x_{0})(x-x_{1}) \cdots (x-x_{n-1})
\end{align*}
$$

```{note}
**Divided Difference Table**

For points $(x_0,f_0), (x_1,f_1), (x_2,f_2), (x_3,f_3)$ the divided differences are computed in a triangular table. Each entry in a higher column is formed from two entries in the previous column:

$$
f[x_i] = f_i,
\qquad
f[x_i, x_{i+1}] = \frac{f_{i+1} - f_i}{x_{i+1} - x_i}, \\

\qquad
f[x_i, \dots, x_{i+k}] = \frac{f[x_{i+1}, \dots, x_{i+k}] - f[x_i, \dots, x_{i+k-1}]}{x_{i+k} - x_i}
$$

Then the triangular table is:

$$
\begin{array}{c|c|c|c|c}
x & f(x) & \text{1st DD} & \text{2nd DD} & \text{3rd DD} \\
\hline
x_0 & f_0 & & & \\
& & f[x_0,x_1] & & \\
x_1 & f_1 & & f[x_0,x_1,x_2] & \\
& & f[x_1,x_2] & & f[x_0,x_1,x_2,x_3] \\
x_2 & f_2 & & f[x_1,x_2,x_3] & \\
& & f[x_2,x_3] & & \\
x_3 & f_3 & & & \\
\end{array}
$$

With the sample values, the table entries become:

$$
f[x_0,x_1]=\frac{f_1-f_0}{x_1-x_0},\qquad
f[x_1,x_2]=\frac{f_2-f_1}{x_2-x_1},\qquad
f[x_2,x_3]=\frac{f_3-f_2}{x_3-x_2}
$$

$$
f[x_0,x_1,x_2]=\frac{f[x_1,x_2]-f[x_0,x_1]}{x_2-x_0},\qquad
f[x_1,x_2,x_3]=\frac{f[x_2,x_3]-f[x_1,x_2]}{x_3-x_1}
$$

$$
f[x_0,x_1,x_2,x_3] = \frac{f[x_1,x_2,x_3] - f[x_0,x_1,x_2]}{x_3-x_0}
$$

These top-left entries provide the Newton interpolation coefficients: $a_0 = f[x_0]$, $a_1 = f[x_0,x_1]$, $a_2 = f[x_0,x_1,x_2]$, $a_3 = f[x_0,x_1,x_2,x_3]$.
```

#### 3.2.3 Finite Differences (Forward, Backward, Central)

##### 3.2.3.1 Forward Difference

For equally spaced points with spacing $h = x_{i+1} - x_i$, the **forward differences** are:

**First forward difference:**

$$\Delta f_i = f_{i+1} - f_i$$

**Second forward difference:**

$$\Delta^2 f_i = \Delta f_{i+1} - \Delta f_i = (f_{i+2} - f_{i+1}) - (f_{i+1} - f_i) = f_{i+2} - 2f_{i+1} + f_i$$

**$n$-th forward difference:**

$$\Delta^n f_i = \sum_{k=0}^{n} (-1)^{n-k} \binom{n}{k} f_{i+k}$$

**Forward Difference Table:**

$$
\begin{array}{c|c|c|c|c}
x & f(x) & \Delta f & \Delta^2 f & \Delta^3 f \\
\hline
x_0 & f_0 & & & \\
& & \Delta f_0 & & \\
x_1 & f_1 & & \Delta^2 f_0 & \\
& & \Delta f_1 & & \Delta^3 f_0 \\
x_2 & f_2 & & \Delta^2 f_1 & \\
& & \Delta f_2 & & \\
x_3 & f_3 & & & \\
\end{array}
$$

where $\Delta f_i = f_{i+1} - f_i$, $\Delta^2 f_i = \Delta f_{i+1} - \Delta f_i$, etc.

##### 3.2.3.2 Backward Difference

The **backward differences** are computed from previous values:

**First backward difference:**

$$\nabla f_i = f_i - f_{i-1}$$

**Second backward difference:**

$$\nabla^2 f_i = \nabla f_i - \nabla f_{i-1} = (f_i - f_{i-1}) - (f_{i-1} - f_{i-2}) = f_i - 2f_{i-1} + f_{i-2}$$

**$n$-th backward difference:**

$$\nabla^n f_i = \sum_{k=0}^{n} (-1)^{k} \binom{n}{k} f_{i-k}$$

**Backward Difference Table:**

$$
\begin{array}{c|c|c|c|c}
x & f(x) & \nabla f & \nabla^2 f & \nabla^3 f \\
\hline
x_0 & f_0 & & & \\
& & \nabla f_1 & & \\
x_1 & f_1 & & \nabla^2 f_2 & \\
& & \nabla f_2 & & \nabla^3 f_3 \\
x_2 & f_2 & & \nabla^2 f_3 & \\
& & \nabla f_3 & & \\
x_3 & f_3 & & & \\
\end{array}
$$

where $\nabla f_i = f_i - f_{i-1}$, $\nabla^2 f_i = \nabla f_i - \nabla f_{i-1}$, etc.

##### 3.2.3.3 Central Difference

The **central differences** are computed using symmetric values around the point:

**First central difference:**
$$\delta f_{i+1/2} = f_{i+1} - f_i$$
or equivalently
$$\delta f_i = \frac{f_{i+1} - f_{i-1}}{2}$$

**Second central difference:**
$$\delta^2 f_i = f_{i+1} - 2f_i + f_{i-1}$$

**$n$-th central difference:**
$$\delta^n f_i = \sum_{k=0}^{n} (-1)^{n-k} \binom{n}{k} f_{i+k-n/2}$$

**Central Difference Table:**

$$
\begin{array}{c|c|c|c|c}
x & f(x) & \delta f & \delta^2 f & \delta^3 f \\
\hline
x_0 & f_0 & & & \\
& & \delta f_{1/2} & & \\
x_1 & f_1 & & \delta^2 f_1 & \\
& & \delta f_{3/2} & & \delta^3 f_{3/2} \\
x_2 & f_2 & & \delta^2 f_2 & \\
& & \delta f_{5/2} & & \\
x_3 & f_3 & & & \\
\end{array}
$$

where $\delta f_{i+1/2} = f_{i+1} - f_i$ and $\delta^2 f_i = f_{i+1} - 2f_i + f_{i-1}$.


#### 3.2.4 Interpolation with Equally Spaced Intervals

##### 3.2.4.1 Newton's Forward and Backward Difference Interpolation
Let $y=f(x)$ takes the values $y_0, y_1, y_2, \cdots, y_n $ corresponding to the equal spaced values $x_0, x_1, x_2, \cdots, x_n $ spacing factor $h$.

We have, by divided difference formula, 

$$
[x_0, x_1] = \frac{y_1 - y_0}{x_1 - x_0} = \frac{\Delta y_{0}}{h}
$$

Similarly, 

$$
[x_0, x_1, x_2, \cdots, x_n] = \frac{\Delta^{2} y_{0}}{n! h^{n}}
$$

Then, the Newton's divided difference formula with $p = (x - x_0)/h$ reduces to:

$$
\begin{align*}
f(x) &= y_{0} + p \Delta y_{0} + \frac{p(p-1)}{2!} \Delta^2 y_{0} + \frac{p(p-1)(p-2)}{3!} \Delta^2 y_{0} \\
    &+ \cdots + \frac{p(p-1)(n-2) \cdots (p-(n-1))}{n!} \Delta^2 y_{0} 
\end{align*}
$$

which is the **Newton-Gregory forward difference interpolation formula**.

Similarly, the **Newton-Gregory backward difference interpolation formula** is given by:

$$
\begin{align*}
f(x) &= y_{n} + p \nabla y_{n} + \frac{p(p+1)}{2!} \nabla^2 y_{n} + \frac{p(p+1)(p+2)}{3!} \nabla^2 y_{n} \\
    &+ \cdots + \frac{p(p+1)(n+2) \cdots (p+(n-1))}{n!} \nabla^2 y_{n} 
\end{align*}
$$

where $
p = \dfrac{x - x_{n}}{h}
$

##### 3.2.4.2 Stirling's and Bessel's Central Difference Interpolation
If $x_0$ lies centrally and the data are equally spaced with step $h$, set

$$
 p = \frac{x - x_0}{h}.
$$

**Stirling’s central difference formula** is useful when the interpolation point is close to the central node $x_0$. It averages the odd-order central differences and uses even-order central differences directly:

$$
\begin{aligned}
y_p &= y_0 + p\,\mu \Delta y_0 + \frac{p^{2}}{2!}\,\Delta^{2} y_0 + \frac{p(p^{2}-1)}{3!}\,\mu \Delta^{3} y_0 \\
&\quad + \frac{p^{2}(p^{2}-1)}{4!}\,\Delta^{4} y_0 + \frac{p(p^{2}-1)(p^{2}-4)}{5!}\,\mu \Delta^{5} y_0 + \cdots
\end{aligned}
$$

where

$$
\mu \Delta y_{0} = \frac{\Delta y_{0} + \Delta y_{-1}}{2}, \qquad
\mu \Delta^{3} y_{0} = \frac{\Delta^{3} y_{0} + \Delta^{3} y_{-1}}{2}.
$$

A Stirling central difference table around $x_0$ is:

$$
\begin{array}{c|c|c|c|c|c}
x & y & \Delta y & \Delta^{2} y & \Delta^{3} y & \Delta^{4} y \\
\hline
x_{-2} & y_{-2} & & & & \\
& & \Delta y_{-2} & & & \\
x_{-1} & y_{-1} & & \Delta^{2} y_{-2} & & \\
& & \Delta y_{-1} & & \Delta^{3} y_{-2} & \\
x_{0} & y_{0} & & \Delta^{2} y_{-1} & & \Delta^{4} y_{-2} \\
& & \Delta y_{0} & & \Delta^{3} y_{-1} & \\
x_{1} & y_{1} & & \Delta^{2} y_{0} & & \\
\end{array}
$$

**Bessel’s central difference formula** is used when the interpolation point lies midway between two central nodes, typically between $x_0$ and $x_1$. Let

$$
 p = \frac{x - x_0}{h} - \frac12.
$$

Then

$$
\begin{aligned}
y_p &= \frac{y_0 + y_1}{2} + p\,\delta y_{1/2} + \frac{p(p-1)}{2!}\,\delta^{2} y_{1} \\
&\quad + \frac{p(p^{2}-1)}{3!}\,\delta^{3} y_{1} + \frac{p(p^{2}-1)(p-2)}{4!}\,\delta^{4} y_{1} + \cdots
\end{aligned}
$$

where

$$
\delta y_{1/2} = y_{1} - y_{0}, \qquad
\delta^{2} y_{1} = y_{2} - 2y_{1} + y_{0}.
$$

A Bessel central difference table for values around the midpoint is:

$$
\begin{array}{c|c|c|c|c}
x & y & \delta y & \delta^{2} y & \delta^{3} y \\
\hline
x_0 & y_0 & & & \\
& & \delta y_{1/2} & & \\
x_1 & y_1 & & \delta^{2} y_1 & \\
& & \delta y_{3/2} & & \delta^{3} y_{1} \\
x_2 & y_2 & & \delta^{2} y_2 & \\
\end{array}
$$

Bessel’s table arranges values so that the midpoint difference $\delta y_{1/2}$ appears between $y_0$ and $y_1$, making the formula accurate for points near the half-step location.

#### 3.3 Cubic spline interpolation 
##### 3.3.1 Equally spaced interval 
Let $ a_0, a_1, a_2, \dots, a_n $ be the second derivatives at $ x_0, x_1, x_2, \dots, x_n $ respectively. For equally spaced points with spacing $h = x_{i+1}-x_i$, the natural cubic spline gives a tridiagonal system:

$$
\begin{bmatrix}
1 & 0 & 0 & \cdots & 0 \\
h & 2(h+h) & h & \cdots & 0 \\
0 & h & 2(h+h) & h & 0 \\
\vdots & \ddots & \ddots & \ddots & \vdots \\
0 & \cdots & 0 & 0 & 1 \\
\end{bmatrix}
\begin{bmatrix}
a_0 \\
a_1 \\
a_2 \\
\vdots \\
a_n \\
\end{bmatrix} 
= 6
\begin{bmatrix}
0 \\
\frac{y_{2}-2y_{1}+y_{0}}{h^2} \\
\frac{y_{3}-2y_{2}+y_{1}}{h^2} \\
\vdots \\
0 \\
\end{bmatrix}
$$

For a natural cubic spline, the endpoint second derivatives are zero:

$$
a_0 = a_n = 0.
$$

On each interval $[x_i, x_{i+1}]$ the spline is

$$
\begin{aligned}
s_i(x) &= \frac{a_i}{6h}(x_{i+1}-x)^3 + \frac{a_{i+1}}{6h}(x-x_i)^3 \\
&\quad + \left(y_i - \frac{a_i h^2}{6} \right) \frac{x_{i+1}-x}{h} + \left(y_{i+1} - \frac{a_{i+1} h^2}{6} \right) \frac{x-x_i}{h}.
\end{aligned}
$$

##### 3.3.2 Unequally spaced interval 
When the nodes are not equally spaced, let $h_i = x_{i+1}-x_i$ for $i=0,1,\dots, n-1$. The natural spline coefficients satisfy:

$$
 h_{i-1} a_{i-1} + 2(h_{i-1}+h_i) a_i + h_i a_{i+1} = 6\left( \frac{y_{i+1}-y_i}{h_i} - \frac{y_i-y_{i-1}}{h_{i-1}} \right), \qquad i=1,2,\dots,n-1.
$$

With natural boundary conditions:

$$
a_0 = a_n = 0.
$$

Each spline piece on $[x_i, x_{i+1}]$ is then:

$$
\begin{aligned}
s_i(x) &= \frac{a_i}{6h_i}(x_{i+1}-x)^3 + \frac{a_{i+1}}{6h_i}(x-x_i)^3 \\
&\quad + \left(y_i - \frac{a_i h_i^2}{6} \right) \frac{x_{i+1}-x}{h_i} + \left(y_{i+1} - \frac{a_{i+1} h_i^2}{6} \right) \frac{x-x_i}{h_i}.
\end{aligned}
$$

This general unequal-spaced formulation reduces to the equal-spaced formulas when all $h_i$ are equal.
