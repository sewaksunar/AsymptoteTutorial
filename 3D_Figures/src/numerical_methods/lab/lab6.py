print("Gauss Seidal Method")
from copy import error
import numpy as np
# import pandas as pd

A = []

n = int(input("Enter the numbers of variables in the system: "))
for i in range(n):
    A.append(list(map(float, input(f"Enter the elements of {i+1}the row:").split())))
A = np.array(A)
N = int(input("Enter the number of iterations: "))
e = float(input("Enter the error tolerance: "))

x = []
for i in range(n):
    x.append(list(map(float, input(f"Enter the initial guess for x{i+1}: "))))
x = np.array(x).flatten()

T = []
for i in range(n):
    d = abs(A[i][i])
    nd = sum(abs(A[i][j]) for j in range(n) if j != i)
    if d <= nd:
        print("The system is not diagonally dominan, may not converge!")

itr = 0
while itr <= N:
    x_old = np.copy(x)
    for i in range(n):
        s = 0
        for j in range(n):
            if j!=i:
                s += A[i][j] * x_old[j] # Jacobi method 
        x[i] = (A[i][-1] - s) / A[i][i]

    err= abs(x - x_old)

    if np.all(err < e):
        break

    x_old = np.copy(x)
    row_data = ([f"Iteration {itr}"] + [f"x{j+1} = {round(x[j], 4)}" for j in range(n)] + [f"Error: {round(err[i], 4)}" for i in range(n)])
    T.append(row_data)
    itr += 1

if itr < N:
    print(f"Converge within {itr} iterations. Final approximation: {x_old}")
    for  i in range(n):
        print(f"x_{i} = {x[i]}")
else:
    print(f"Does not converge in {itr} iterations. Final approximation: {x}")
    for  i in range(n):
        print(f"x_{i} = {np.round(x[i], 2)}")
