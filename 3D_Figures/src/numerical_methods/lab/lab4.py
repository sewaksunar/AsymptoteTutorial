print("Gauss Elimination Method")
import numpy as np


n = int(input("Enter the numbers of variables in the system: "))
A = []
print("Enter the augumented matrix:")
for i in range(n):
    # A.append([float(input(f"Enter the elements A{i+1}{j+1} :")) for j in range(n+1)])
    A.append(list(map(float, input(f"Enter the elements of {i+1}the row:").split())))

A = np.array(A)
# print(A)

# pivotm = []
# for i in range(n):
#     pivotm.append(np.max(abs(A[i:n, i])))
# print(pivotm)

for i in range(n):
    pivot = np.argmax(abs(A[i:n, i])) + i
    # print(pivot)
    if pivot != i:
        A[[i, pivot]] = A[[pivot, i]]

    if A[pivot, i] == 0:
        print("Matrix is singular, system is inconsistent!")
        exit(0)
    
    for j in range(i+1, n): 
        A[j] = A[j] - A[j][i] / A[i][i] * A[i] 

# for i in range(n-1, -1, -1):
#     for j in range(i+1, n):
#         A[i] = A[i] - A[i][j] / A[j][j] * A[j]
#     A[i] = A[i] / A[i][i]
# print("Solution vector:")
x = np.zeros(n)
for i in range(n-1, -1, -1):
    s = np.dot(A[i][i+1:n], x[i+1:n])   # dot product of coefficients and known x’s
    x[i] = (A[i][-1] - s) / A[i][i]

print("Upper Triangular Matrix:")
print(A)
print("Solution vector:")
print(x)
