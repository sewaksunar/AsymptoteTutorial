import numpy as np
import scipy as sc
import pandas as pd
import scipy.interpolate as sci
import matplotlib.pyplot as plt

# fn = input("Enter ODE the dy/dx = f(x, y): ")
fn = "np.sin(x)+np.cos(x)-y"
def f(x, y):
    try:
        return eval(fn)
    except (SyntaxError, NameError, TypeError):
        print("Invalid syntax")
        exit(0)

# x = float(input("Enter inital guess x_O:"))
# y = float(input("Enter inital guess y_O:"))
x=0
y=1
h = float(input("Enter the step-size h:"))
# n = int(input("Enter the number of partition (n): "))
n=5
xvals = [x]
yvals = [y]
results = []
for i in range(n):
    k1 = h * f(x, y)
    k2 = h * f(x + h/2, y + k1/2)
    k3 = h * f(x + h/2, y + k2/2)
    k4 = h * f(x + h, y + k3)
    y = y + (k1 + 2*(k2 + k3) + k4)/6
    x = x+h
    results.append([x, y])
    xvals.append(x)
    yvals.append(y)

table = pd.DataFrame(results, columns=["x", 'y'])
print(table.to_string(index=True))

lag_poly = sci.lagrange(xvals, yvals)
plt.plot(xvals, lag_poly(xvals), label="solution by RK-4 method", marker="x")
plt.show()

