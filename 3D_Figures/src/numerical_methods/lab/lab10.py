import numpy as np
import scipy.integrate as sc
import scipy.interpolate as sci
import matplotlib.pyplot as plt
fn = input("Enter the function of x using python syntax: ")

def f(x):
    try:
        return eval(fn)
    except (SyntaxError, NameError, TypeError):
        print("Invalid syntax")
        exit(0)
    
a = float(input("Enter the lower limits of integration a: "))
b = float(input("Enter the upper limits of integration b: "))

n = int(input("Enter the number of partitions: "))
# n = 10
if n%2 != 0:
    print("Number of partitions must be even (multiple of 2)!")
    exit(0)

h = (b-a)/n

x = np.linspace(a, b, n+1)
Y = [f(x) for x in x]

I = 0
I = Y[0] + Y[-1]
I = I + 4 * sum(Y[1:-1:2])
I = I + 2 * sum(Y[2:-1:2])
I = I * h/3

print(f"Approximate integral is {I}")

eI = sc.quad(lambda x: f(x), a, b)[0]

print(f"Exact integral is {eI}")

print(f"Error = {abs(eI - I)}")

# plot
x = np.linspace(a, b, n+1)
x1 = np.linspace(a - 3, b+3, 1000)

plt.plot(x1, f(x1))
plt.show()

for i in range(0, n, 2):
    X = x[i: i+3]
    Yp = f(X)

    L = np.linspace(X[0], X[2], 1000)

    lag_poly = sci.lagrange(X, Yp)
    lp = lag_poly(L)

    plt.plot(L, lp, color="red", alpha=0.6)
    plt.fill_between(L, 0, lp, color="yellow", alpha=0.8)
    plt.fill_between(L, f(L), lp, color="black", alpha=0.5)

    for j in range(0,3,2):
        x2 = X[j]
        l_p = lag_poly(x2)
        plt.plot((x2, x2), (0, l_p), color="green")
# plt.axhline(y=0, color="blue")
# plt.axhline(x=0, color='blue')
plt.show()