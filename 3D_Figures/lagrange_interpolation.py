import matplotlib.pyplot as plt
import numpy as np
import sympy as sp

print("--- Lagrange Interpolation ---")

# Input Data
# X = np.array([110, 130, 160, 190])
# Y = np.array([10.8, 8.1, 5.5, 4.8])

# X = np.array([0, 2, 4, 6, 8, 10])
# Y = np.array([1.2, 1.6, 2, 3.3, 3.6, 4.2])

# X = np.array([0, 2, 4, 6, 8, 10])
# Y = np.array([1.2, 1.6, 2, 3.3, 4.2, 5.5])

X = np.array([3, 5, 3.1, 4, 3.5, 5])
Y = np.array([1.2, 1.6, 2, 3.3, 4.2, 5.5])

# Validation
if len(X) != len(Y):
    print("Error: The number of X and Y values must be the same.")
    exit(0)

n = len(X)

# Cleaned up data printing using string joining
print("X:\t" + "\t".join(map(str, X)))
print("Y:\t" + "\t".join(map(str, Y)))
print("-" * 30)

# Define SymPy symbol outside the loops
x = sp.symbols("x")
lp = 0

# Lagrange Polynomial Generation
for i in range(n):
    Li = 1
    for j in range(n):
        if j != i:
            Li = Li * ((x - X[j]) / (X[i] - X[j]))
    lp = lp + Y[i] * Li

# Simplify expression nicely
lp_simplified = sp.nsimplify(lp.evalf(), rational=True, tolerance=1e-10)
P_expr = sp.simplify(lp_simplified)
equation_string = f"P(x) = {P_expr}"
print(equation_string)

# Get target interpolation value from user
xp = float(input("\nEnter the x_p to interpolate: "))
interpolated_value = float(P_expr.subs(x, xp))
print(f"Interpolated value at {xp}: {interpolated_value:.4f}")

# --- Plotting ---

# Convert the symbolic expression to a fast NumPy function for plotting
P_func = sp.lambdify(x, P_expr, "numpy")
w = np.linspace(np.min(X) - 5, np.max(X) + 5, 200)

plt.figure(figsize=(10, 6))

# Plot the Lagrange polynomial curve
plt.plot(w, P_func(w), label="Lagrange Polynomial", color="blue", zorder=1)

# Plot historical data points
plt.scatter(X, Y, label="Data Points", color="red", s=50, zorder=2)

# Plot the user-requested interpolated point
plt.scatter(
    xp, 
    interpolated_value, 
    label=f"Interpolated Point ({xp}, {interpolated_value:.2f})", 
    color="green", 
    s=80, 
    marker="X", 
    zorder=3
)

# Graph styling details
plt.xlabel("X-axis")
plt.ylabel("Y-axis")
plt.title("Lagrange Interpolation Polynomial Fit")
plt.legend()
plt.grid(True, linestyle="--", alpha=0.6)

# Display the plot
plt.show()