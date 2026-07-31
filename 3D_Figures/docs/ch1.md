# Chapter 1: Solution of Non-Linear Equations

This course module on the **Solution of Non-Linear Equations** covers the fundamental numerical techniques used to find the roots (or zeros) of functions where analytical solutions are difficult or impossible to obtain.

### **1.1 Errors and Accuracy in Numerical Computations**
Numerical methods yield **approximate results**, and understanding the associated errors is critical for engineering applications.
*   **Accuracy vs. Precision:** **Accuracy** refers to how closely a computed value agrees with the true value. **Precision** refers to how closely individual computed values agree with each other.
*   **True Error ($E_t$):** The difference between the true value and the approximation.

    $$E_t = \text{true value} - \text{approximation}$$
*   **True Percent Relative Error ($\epsilon_t$):** Normalises the error to the true value.

    $$\epsilon_t = \frac{\text{true error}}{\text{true value}} \times 100\%$$
*   **Approximate Percent Relative Error ($\epsilon_a$):** Used in iterative methods when the true value is unknown, comparing the current and previous approximations.

    $$\epsilon_a = \left| \frac{\text{current approximation} - \text{previous approximation}}{\text{current approximation}} \right| \times 100\%$$
*   **Stopping Criterion ($\epsilon_s$):** Iterations are terminated when the error falls below a prespecified tolerance.

    $$|\epsilon_a| < \epsilon_s$$

    To ensure the result is correct to $n$ significant figures, use:

    $$\epsilon_s = (0.5 \times 10^{2-n})\%$$
*   **Sources of Error:**
    *   **Round-Off Error:** Due to the computer's inability to represent certain numbers exactly with a finite number of digits.
    *   **Truncation Error:** Results from using an approximation in place of an exact mathematical procedure, such as truncating a **Taylor series**.

### **1.2 Bisection Method**
A **bracketing method** based on the Intermediate Value Theorem. If a continuous function $f(x)$ changes sign over an interval $[x_l, x_u]$, at least one real root exists between them.
*   **Algorithm:** The interval is repeatedly halved. The root estimate is the midpoint:

    $$
    \begin{align*}
    x_r = \frac{x_l + x_u}{2}
    \end{align*}
    $$
*   **Iteration Requirement:** The number of iterations ($n$) required to reach a specific absolute error ($E_{a,d}$) can be calculated a priori:

    $$n = \log_2 \left( \frac{\Delta x_0}{E_{a,d}} \right) \quad \text{where } \Delta x_0 = x_u^0 - x_l^0$$
```{note}
It is stable and guaranteed to converge, but it is relatively slow compared to open methods.
```

### **1.3 Regula Falsi and Secant Methods**
*   **Regula Falsi (False Position):** A bracketing method that uses linear interpolation. It joins $f(x_l)$ and $f(x_u)$ with a straight line; the point where this line crosses the x-axis is the root estimate.

    $$
    x_r = x_u - \frac{(x_l - x_u)}{f(x_l) - f(x_u)}f(x_u)
    $$

*   **Secant Method:** An open method that uses a similar formula but does not require the root to be bracketed. It uses two initial estimates and calculates the slope using a backward finite divided difference.

    $$
    x_{i+1} = x_i - \frac{(x_{i-1} - x_i)}{f(x_{i-1}) - f(x_i)}f(x_i)
    $$
```{note}
Unlike Regula Falsi, the Secant method can occasionally diverge if initial guesses are poor.
```

### **1.4 Newton-Raphson Method**
The most widely used root-locating formula. It uses a tangent line at an initial guess $x_i$ to find an improved estimate $x_{i+1}$.
*   **Formula:**

    $$
    x_{i+1} = x_i - \frac{f(x_i)}{f'(x_i)}
    $$

```{warning}
It is quadratically convergent, meaning the number of significant digits approximately doubles each iteration. However, it requires an analytical derivative and may fail if $f'(x) \approx 0$.
```

### **1.5 Fixed Point Iteration Method**
Also known as one-point iteration, it involves rearranging $f(x) = 0$ into the form $x = g(x)$.
*   **Formula:**

    $$x_{i+1} = g(x_i)$$
*   **Convergence Requirement:** The method converges if the magnitude of the slope $|g'(x)| < 1$ in the region of interest. It typically exhibits linear convergence.

### **1.6 Comparison of the Methods**
*   **Bracketing vs. Open-Ended:** Bracketing methods (Bisection, Regula Falsi) are slower but always converge. Open methods (Newton-Raphson, Secant, Fixed Point) are much faster but can diverge.
*   **Rates of Convergence:**
    *   **Bisection:** Linear (Slowest).
    *   **Fixed Point:** Linear.
    *   **Newton-Raphson:** Quadratic (Fastest).
    *   **Secant:** Super-linear (Faster than bisection, slower than NR).

### **1.7 Solution of System of Non-Linear Equations**
*   **1.7.1 Direct Approach (Fixed Point):** The single-variable method is extended by solving each equation in a system for a different unknown. Convergence is highly dependent on how the equations are formulated.
*   **1.7.2 Newton-Raphson Method for Systems:** Uses a **Jacobian matrix** of partial derivatives to solve multiple equations simultaneously.
    For a two-equation system $f(x,y)=0$ and $g(x,y)=0$:

    $$
    \begin{aligned}
    x_{i+1} &= x_i - \frac{f_i \dfrac{\partial g_i}{\partial y} - g_i \dfrac{\partial f_i}{\partial y}}{J(f_i, g_i)} \\
    y_{i+1} &= y_i - \dfrac{g_i \dfrac{\partial f_i}{\partial x} - f_i \dfrac{\partial g_i}{\partial x}}{J(f_i, g_i)}
    \end{aligned}
    $$           

    Where the **Jacobian ($J$)** is:

    $$
    J = \frac{\partial f_i}{\partial x} \frac{\partial g_i}{\partial y} - \frac{\partial f_i}{\partial y} \frac{\partial g_i}{\partial x}
    $$

For solving a system of two non-linear equations, such as $f(x, y) = 0$ and $g(x, y) = 0$, the **Newton-Raphson method** can be expressed concisely in **matrix form** using a multi-variable Taylor series expansion.

1. The Jacobian Matrix**
The core of the multi-equation Newton-Raphson method is the **Jacobian matrix** (denoted as $[J]$ or $[J]$), which consists of the partial derivatives of the equations with respect to each unknown. For two equations, the matrix is:

$$
[J] = \begin{bmatrix}
\frac{\partial f_i}{\partial x} & \frac{\partial f_i}{\partial y} \\
\frac{\partial g_i}{\partial x} & \frac{\partial g_i}{\partial y}
\end{bmatrix}
$$

The determinant of this matrix is referred to as the **Jacobian determinant** ($J$):

$$
J = \frac{\partial f_i}{\partial x} \frac{\partial g_i}{\partial y} - \frac{\partial f_i}{\partial y} \frac{\partial g_i}{\partial x}
$$

2. The Matrix Update Equation**
The relationship to determine the refined estimates $\{X_{i+1}\}$ from the current estimates $\{X_i\}$ is represented as a set of linear simultaneous equations:

$$[J]\{X_{i+1}\} = -\{F_i\} + [J]\{X_i\}$$

Where:
$\{X_i\} = \begin{bmatrix} x_i \\ y_i \end{bmatrix}$, 
$\{X_{i+1}\} = \begin{bmatrix} x_{i+1} \\ y_{i+1} \end{bmatrix}$, 
$\{F_i\} = \begin{bmatrix} u(x_i, y_i) \\ v(x_i, y_i) \end{bmatrix}$.

3. Solution via Matrix Inversion (Formal Representation)**
While often solved using techniques like Gauss elimination for efficiency, the formal solution using matrix algebra is:

$$
\{X_{i+1}\} = \{X_i\} - [J]^{-1}\{F_i\}
$$

This formula shows that the next estimate is obtained by subtracting the product of the inverse Jacobian and the function vector from the current estimate.

```{note}
*   **Linear System:** At each iteration, the matrix form represents a set of linear equations that can be solved for the unknowns $x_{i+1}$ and $y_{i+1}$.
*   **Convergence:** Like the single-equation version, this method is highly efficient but may diverge if initial guesses are not sufficiently close to the true roots.
*   **Shortcomings:** Evaluating the partial derivatives in the Jacobian matrix $[J]$ can sometimes be inconvenient or difficult; in such cases, finite-difference approximations are often used instead.
```
