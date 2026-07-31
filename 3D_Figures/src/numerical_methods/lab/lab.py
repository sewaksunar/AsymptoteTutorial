print("LU Method")
import numpy as np


n = int(input("Enter the numbers of variables in the system: "))
A = []
print("Enter the coefficient matrix:")
for i in range(n):
    A.append(list(map(float, input(f"Enter the elements of {i+1}th row:").split())))

A = np.array(A)
print(f"Input Coefficient Matrix:\n{A}")

L, U = np.zeros((n, n)), np.zeros((n, n))
for i in range(n):
  for j in range(n):
    if i == 0:
        U[i][j] = A[i][j]
    if i==j:
       L[i][j] = 1
    if i != j and i < j:
       L[i][j] = 0
    if i != j and i > j:
       U[i][j] = 0
    if j == 0 and i >= 1:
       L[i][j] = A[i][j]/U[j][j]

    s = 0
    for k in range(j):
        if i >= 1 and j >= 1 and i <= j:
            s += L[i][k] * U[k][j]
    if i >= 1 and j >= 1 and i <= j:
            U[i][j] = A[i][j] - s
    S = 0
    for t in range(j):
        if i >= 1 and j >= 1 and i > j:
            S += L[i][t] * U[t][j]
    if i >= 1 and j >= 1 and i > j:
            L[i][j] = (A[i][j] - S) / U[j][j]

print(f"Lower Triangular Matrix L: \n {L}")
print(f"Upper Triangular Matrix U: \n {U}")

# solution phase
B = A[:, -1:]
V = np.linalg.solve(L, B)
print(f"the matirx V is: \n {V}")
X = np.linalg.solve(U, V)
print(f"the solution vector X is: \n {X}")
for i in range(n):
    # s = 0
    # for k in range(i):
    #     s += U[i][k] * V[k]
    # V[i] = (V[i] - s) / U[i][i]
    print(f"x{i+1} = {round(X[i][0], 2)}")