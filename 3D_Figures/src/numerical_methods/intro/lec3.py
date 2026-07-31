import numpy as np
import matplotlib.pyplot as plt

fun = input("Enter the function of x using python syntax: ")


def F(x, fun):
    return eval(fun)

def f(x):
    return F(x, fun)


x = np.linspace(-5, 10, 50)

plt.plot(x, f(x), color='blue', linestyle='--', label='f(x) = exp(x) + sin(x) - 9')

plt.axhline(0, color='red', linewidth=0.5)
plt.axvline(0, color='blue', linewidth=0.5)

plt.grid(True, which='major', linestyle='--', linewidth=0.5)

plt.title('Graph of the function f(x)')
plt.xlabel('x-axis')
plt.ylabel('y-axis')
plt.legend(loc='upper left')
plt.show()

