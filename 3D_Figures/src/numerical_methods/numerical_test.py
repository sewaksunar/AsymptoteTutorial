import numpy as np
import matplotlib.pyplot as plt

def f(x):
    return x**3 - 4*x - 9  # Example function: f(x) = x^3 - 4x - 9

def bisection(a, b, tol):
    if f(a) * f(b) >= 0:
        print("Bisection method fails. f(a) and f(b) must have opposite signs.")
        return None
    
    while (b - a) / 2.0 > tol:
        midpoint = (a + b) / 2.0
        if f(midpoint) == 0:
            return midpoint
        elif f(a) * f(midpoint) < 0:
            b = midpoint
        else:
            a = midpoint
    return (a + b) / 2.0

# Solve
root = bisection(2, 3, 0.0001)
print(f"The root is approximately: {root:.4f}")

# Plotting to verify
x = np.linspace(1, 4, 100)
plt.plot(x, f(x), label='f(x) = x³ - 4x - 9')
plt.axhline(0, color='red', linestyle='--')
plt.scatter(root, 0, color='green', label=f'Root ~ {root:.2f}')
plt.legend()
plt.title("Numerical Method: Bisection Verification")
plt.grid(True)
plt.show()