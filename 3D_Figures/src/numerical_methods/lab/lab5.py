print("Gauss Jordan Method")
import numpy as np


n = int(input("Enter the numbers of variables in the system: "))
A = []
print("Enter the augumented matrix:")
for i in range(n):
    A.append(list(map(float, input(f"Enter the elements of {i+1}the row:").split())))

A = np.array(A)
print(f"Input Augmented Matrix:\n{A}")

# Determine if input is an augmented matrix (n x (n+1)) or just n x n
cols = A.shape[1]
if cols == n + 1:
    coeff = A[:, :-1].astype(float)
    b = A[:, -1].astype(float)
    is_augmented = True
elif cols == n:
    coeff = A.astype(float)
    b = None
    is_augmented = False
else:
    raise ValueError("Input matrix dimensions do not match the number of variables")

# Doolittle LU decomposition (coeff must be square n x n)
if coeff.shape != (n, n):
    raise ValueError("Coefficient matrix must be square n x n")

tol = 1e-12
L = np.zeros((n, n), dtype=float)
U = np.zeros((n, n), dtype=float)
for i in range(n):
    # compute U[i,j] for j >= i
    for j in range(i, n):
        s = sum(L[i, k] * U[k, j] for k in range(i))
        U[i, j] = coeff[i, j] - s
    if abs(U[i, i]) < tol:
        raise ZeroDivisionError(f"Zero pivot encountered at U[{i},{i}]")
    L[i, i] = 1.0
    for j in range(i + 1, n):
        s = sum(L[j, k] * U[k, i] for k in range(i))
        L[j, i] = (coeff[j, i] - s) / U[i, i]

print(f"Lower Triangular Matrix L: \n{L}")
print(f"Upper Triangular Matrix U: \n{U}")

# If augmented, solve Ly = b then Ux = y
if is_augmented:
    y = np.zeros(n, dtype=float)
    for i in range(n):
        y[i] = b[i] - sum(L[i, k] * y[k] for k in range(i))
    x = np.zeros(n, dtype=float)
    for i in range(n - 1, -1, -1):
        x[i] = (y[i] - sum(U[i, k] * x[k] for k in range(i + 1, n))) / U[i, i]
    print(f"Solution x: {x}")

