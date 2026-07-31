import numpy as np
import matplotlib.pyplot as plt
import scipy.interpolate as interpolate
import pandas as pd
import sympy as sp

print("Lagrange Interpolation")

X = np.array([110, 130, 160, 190])
Y = np.array([10.8, 8.1, 5.5, 4.8])

# x = float(input("enter"))
##################################
## 
##################################
if len(X) != len(Y):
    print("Error: The number of X and Y values must be the same.")
    exit(0)

n = len(X)

print("X:", end=" ")
for i in range(n):
    print(f"{X[i] }", end="\t")
    if i == n-1:
        print(f"{X[i]}", end="\n")

print("Y:", end=" ") 
for i in range(n):
    print(f"{Y[i]}", end="\t")
    if i == n-1:
        print(f"{Y[i]}", end="\n")

lp = 0

for i in range(n):
    x = sp.symbols("x")
    Li = 1
    for j in range(n):
        if j!=i:
            Li = Li * ((x-X[j])/(X[i]-X[j]))
    lp = lp + Y[i] * Li

lp = sp.nsimplify(lp.evalf(), rational=True, tolerance=1e-10)
P = sp.simplify(lp)
exp = P
exp = f"P(x) = {exp}"
print(exp)

xp = float(input(f"Enter the x_p:"))
print(f"Interpolated value: {P.subs(x, xp)}")

# plot

# w = np.linalg(np.min(X)-2, np.max(X)+2)
P = sp.lambdify(x, P, "numpy")
w = np.linspace(np.min(X)-2, np.max(X)+2, 100)
plt.plot(w, P(w), label=exp)
plt.scatter(X, Y, label="Data Points", color="red")
lxp = f"Interpolate value of {xp}"
plt.scatter(x=xp, y=P(xp), label=lxp, color="green")
plt.xlabel('X-axis')
plt.ylabel('Y-axis')
plt.title('Plot')
plt.legend()
plt.grid(True)
plt.show()