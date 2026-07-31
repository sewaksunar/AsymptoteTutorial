print("Power Method - input and initialization phase")
import numpy as np
import pandas as pd
n = int(input("Enter the matrix size (square):"))
# n =3
A = []
for i in range(n):
    A.append(list(map(float, input(f"Enter the elements of {i+1}the row:").split())))
# A = [[1, 6, 1],
#      [1, 2, 0],
#      [0, 0, 3]]

A = np.array(A)

Nmax = 100
e = 1e-10
X0 = []
for i in range(3):
    X0.append(float(input(f"Enter the initial guess for X[{i}]: ")))

lold = 0
k = 1

X = X0

T = []

while k <= Nmax:
    Y = np.dot(A, X)

    lnew = np.max(abs(Y))

    x = Y/lnew

    err = abs(lnew - lold)   
    T.append([k, X, lnew, x, err])
    if err < e:
        break
    lold = lnew
    X = x
    k +=1

if k > Nmax:
    print(f"doesn't converge in {Nmax}")
else:
    print(f'converge in {k}')
    print(f"Dominant eigenvlaue: {lnew}")
    print(f"corresponding eighenvecor: {x}")

    column = ['iteration', 'eigenvector', 'eigenvalue', 'normalized eigenvector', 'error']
    df = pd.DataFrame(T, columns=column)
    print(df)