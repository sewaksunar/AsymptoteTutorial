from numerical_methods.solvers.roots import bisection_method
from numerical_methods.solvers.newton_raphson import NewtonRaphson

# Define target: f(x) = x^2 - 2 (Root should be sqrt(2) ≈ 1.414)
def f(x): return x**2 - 2
def df(x): return 2*x

print("--- Comparing Solvers ---")

# 1. Using the Function-based Bisection
root_b = bisection_method(f, 1, 2)
print(f"Bisection Root: {root_b:.6f}")

# 2. Using the Class-based Newton-Raphson
nr_solver = NewtonRaphson(f, df)
root_nr = nr_solver.solve(x0=1.5)
print(f"Newton-Raphson Root: {root_nr:.6f}")
print(f"NR took {len(nr_solver.history)} iterations.")