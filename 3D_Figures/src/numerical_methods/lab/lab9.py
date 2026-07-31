import numpy as np
import sympy as sp
import matplotlib.pyplot as plt
# import pandas as pd

x = [1, 2, 4, 8, 9]
y = [3, 4, 5, 2, 1]

if len(x)!=len(y):
    print(r"Number of $x$-data and $y$-data must be equal!")

n = len(x)

print(r"Data points are:")

for i in range(n):
    print(r"$(x_{%d}, y_{%d}) = (%d, %d)$" % (i, i, x[i], y[i]))