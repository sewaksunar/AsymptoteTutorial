# Chapter 2: System of Linear Equations

This note covers the **Solution of System of Linear Algebraic Equations**, a fundamental area of numerical methods used in engineering to model systems such as structures, electric circuits, and fluid networks.

### **2.1 Direct Methods**
Direct methods compute the solution in a finite number of operations. The general form of a linear system is $[A]\{X\} = \{B\}$, where $[A]$ is the coefficient matrix, $\{X\}$ is the vector of unknowns, and $\{B\}$ is the vector of constants.

#### **2.1.1 Gauss Elimination and Pivoting**
This method reduces the system to an **upper triangular form** through forward elimination and then solves for unknowns via **back substitution**.
*   **Forward Elimination:** The objective is to eliminate $x_1$ from the second to the $n$th equation, then $x_2$ from the third to $n$th, and so on.
    *   **Multiplier formula:** 
    
    $$
    \begin{align*}
    f_{ik} = \frac{a_{ik}} {a_{kk}}
    \end{align*}
    $$

    *   **Row transformation:** 

    $$
    \begin{align*}
    a_{ij}^{new} &= a_{ij} - f_{ik} \cdot a_{kj} \\
    b_i^{new} &= b_i - f_{ik} \cdot b_k
    \end{align*}
    $$

*   **Back Substitution:** Once the matrix is triangular, unknowns are solved from the bottom up.
    *   **Formula:** 

    $$
    \begin{align*}
    x_n &= \frac{b_n}{a_{nn}}  \\
    x_i &= \frac{b_i - \sum_{j=i+1}^n a_{ij}x_j}{a_{ii}}
    \end{align*}
    $$

```{note}
**Pivoting Strategies:** "Naive" Gauss elimination fails if a pivot element ($a_{kk}$) is zero. Partial Pivoting involves switching the pivot row with the row below it that contains the largest absolute coefficient in the pivot column to avoid division by zero and minimize round-off errors.
To get a pivot row or column, you typically follow strategies designed to ensure numerical stability and avoid division by zero during processes like Gauss elimination or LU decomposition.

 **Summary Table for Linear Algebra**

$$
\begin{array}{c|c|c}
\text{Strategy} & \text{Search Area} & \text{Objective} \\
\hline
\textbf{Naive} & \text{None (uses current diagonal)} & \text{Speed (but unstable if diagonal is 0)} \\
\textbf{Partial} & \text{Column below current diagonal} & \text{Largest absolute value in column} \\
\textbf{Complete} & \text{Entire remaining submatrix} & \text{Largest absolute value in the submatrix} \\
\end{array}
$$

```


#### **2.1.2 Gauss-Jordan Method**
A variation where unknowns are eliminated from **all equations** (above and below the pivot), and each row is normalised by its pivot element. This transforms the coefficient matrix directly into an **identity matrix**, yielding the solution in the constant vector $\{B\}$ without requiring back substitution. It requires approximately 50% more operations than standard Gauss elimination.

#### 2.1.3 Matrix inverse using Gauss Jordan and Gauss elimination methods
##### 2.1.3.1 Gauss Jordan Methods

Gauss-Jordan elimination transforms the coefficient matrix into an identity matrix.

#### 2.1.3.2 Factorization methods
Every square matrix $A$ with all non-zero principal minors can be factored uniquely into a lower triangular matrix $L$ and upper triangular matrix $U$ as:

$$
\begin{align*}
[A] = [L][U]
\end{align*}
$$

**Method:** Consider the system of linear equations:

$$
    \begin{align*}
    a_{11} x_1 + a_{12} x_2 + \cdots + a_{1n} x_n &= b_1 \\
    a_{21} x_1 + a_{22} x_2 + \cdots + a_{2n} x_n &= b_2 \\
    \vdots \\
    a_{n1} x_1 + a_{n2} x_2 + \cdots + a_{nn} x_n &= b_n
    \end{align*}
$$

which can be written as:

$$
\begin{align*}
[A][X] = [B]
\end{align*}
$$
where

$$
\begin{align*}
[A] = \begin{bmatrix}
a_{11} & a_{12} & \cdots & a_{1n} \\
a_{21} & a_{22} & \cdots & a_{2n} \\
\vdots & \vdots & \ddots & \vdots \\
a_{n1} & a_{n2} & \cdots & a_{nn}
\end{bmatrix}, \qquad
[X] = \begin{bmatrix} x_1 \\ x_2 \\ \vdots \\ x_n \end{bmatrix}, \qquad
[B] = \begin{bmatrix} b_1 \\ b_2 \\ \vdots \\ b_n \end{bmatrix}
\end{align*}
$$

Then, if $[A] = [L][U]$, the system can be rewritten as:

$$
\begin{align}
([L][U])[X] &= [B] \\
[L]([U][X]) &= [B] \\
[L][V] &= [B]
\end{align}
$$

where we define $[V] = [U][X]$.

**Solution Steps:**
1. Solve $[L][V] = [B]$ for $[V]$ (forward substitution)
2. Solve $[U][X] = [V]$ for $[X]$ (back substitution)

**Example:** Consider a $3 \times 3$ system:
    $
    \begin{align*}
    [A] = \begin{bmatrix}
            a_{11} & a_{12} & a_{13} \\
            a_{21} & a_{22} & a_{23} \\
            a_{31} & a_{32} & a_{33}
            \end{bmatrix}
    \end{align*}
    $

**Do-Little's method:**
    $
    \begin{align*}
    [L] = \begin{bmatrix}
            1 & 0 & 0 \\
            l_{21} & 1 & 0 \\
            l_{31} & l_{32} & 1
            \end{bmatrix}, \qquad
    [U] = \begin{bmatrix}
            u_{11} & u_{12} & u_{13} \\
            0 & u_{22} & u_{23} \\
            0 & 0 & u_{33}
            \end{bmatrix}
    \end{align*}
    $

**Crout's method:**
    $
    \begin{align*}
    [L] = \begin{bmatrix}
            l_{11} & 0 & 0 \\
            l_{21} & l_{22} & 0 \\
            l_{31} & l_{32} & l_{33}
            \end{bmatrix} , \qquad
    [U] = \begin{bmatrix}
            1 & u_{12} & u_{13} \\
            0 & 1 & u_{23} \\
            0 & 0 & 1
            \end{bmatrix}
    \end{align*}
    $


---

### **2.2 Iterative Methods**
Iterative methods start with an initial guess and refine it until the solution converges within a tolerance.

#### 2.2.1 Jacobi’s Method (Method of Simultaneous Displacement):
It uses only values from the **previous iteration** to calculate the new set of estimates, waiting until the entire iteration is complete to update variables.

**Iterative formula:**

$$
\begin{equation}
x_i = \frac{1}{a_{ii}} \left( b_i - \sum_{j=1, j \neq i}^n a_{ij}x_j \right)
\end{equation}
$$

**Convergence Criterion:** Convergence is guaranteed if the matrix is **diagonally dominant**:

$$
\begin{align*}
|a_{ii}| > \sum_{j=1, j \neq i}^n |a_{ij}|
\end{align*}
$$

#### 2.2.2 Gauss-Seidel Method:
The most common iterative technique, which **immediately uses the latest available estimates** for each unknown as they are computed.

If $x = x_{1}^{(n)}, x_{2}^{(n)}, x_{3}^{(n)}, \cdots, x_{n}^{(n)}$ be the $n^{th}$ approximation to the system (2), then the $ (n+1)^{th}$ approximation to the root is given by, 

$$
\begin{align*}
x_{1}^{(n+1)} &= \frac{1}{a_{11}}[b_{1} - a_{12}x_{2}^{(n)} - a_{13}x_{3}^{(n)} - \cdots - a_{1n}x_{n}^{(n)}] \\
x_{2}^{(n+1)} &= \frac{1}{a_{22}}[b_{2} - a_{21}x_{1}^{(n+1)} - a_{23}x_{3}^{(n)} - \cdots - a_{2n}x_{n}^{(n)}] \\
\vdots \\
x_{n}^{(n+1)} &= \frac{1}{a_{nn}}[b_{n} - a_{n1}x_{1}^{(n+1)} - a_{n2}x_{2}^{(n+1)} - \cdots - a_{n(n-1)}x_{n-1}^{(n+1)}]
\end{align*}
$$

### **2.3 Eigenvalues and Eigenvectors (The Power Method)**
**Largest Eigenvalue:** The **Power Method** iteratively multiplies a guess vector by the matrix and normalizes the result until it converges to the dominant eigenvalue and its corresponding vector.


Given a square matrix $A$. Let $X^{(0)}$ be the initial vector so that 

$$
\begin{align*}
Y^{(1)} =AX^{(0)}
\end{align*}
$$

then, 

$$
\begin{align*}
AX^{(0)} &= \lambda_{1} X^{(1)} \\ 
AX^{(1)} &= \lambda_{2} X^{(2)} \\ 
        & \vdots \\
AX^{(n)} &= \lambda_{n+1} X^{(n+1)} \\ 
\end{align*}
$$

Which can be written, 

$$
\begin{align*}
X^{(1)} &= \frac{1}{k_{1}}Y^{(1)} \\ 
X^{(2)} &= \frac{1}{k_{2}} X^{(2)} \\ 
        & \vdots \\
X^{(n)} &= \frac{1}{k_{n}} X^{(n)} \\ 
\end{align*}
$$

where $k_n$ is the absolutely largest element of $Y^{(n)}$. Then the sequence $k_1, k_2, \cdots, k_n$ converges to the numerically dominant eigenvalues of matrix $A$. The $X^{(n)}$ is the corresponding eigenvector of $\lambda_{n}$.

**Smallest Eigenvalue:** Determined by applying the power method to the **inverse matrix $[A]^{-1}$**; the result is the reciprocal of the smallest eigenvalue and corresponding eigen vector.

---

### **Practical Implementation (Python)**
The syllabus requires implementing these algorithms in **Python**, utilizing libraries like **NumPy** and **SciPy**:
*   `numpy.linalg.solve(A, y)`: Solves linear systems using LU decomposition.
*   `scipy.linalg.lu(A)`: Returns the permutation matrix $P$, and the $L$ and $U$ factors.
*   `numpy.linalg.eig(A)`: Computes eigenvalues and eigenvectors.
*   `numpy.linalg.inv(A)`: Computes the matrix inverse.