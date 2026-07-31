import numpy as np

def bisection_method(func, a: float, b: float, tol: float = 1e-6, max_iter: int = 100):
    """
    Finds the root of a function using the Bisection Method.
    """
    if func(a) * func(b) >= 0:
        raise ValueError("Root is not bracketed. f(a) and f(b) must have opposite signs.")

    iteration = 0
    while (b - a) / 2.0 > tol and iteration < max_iter:
        midpoint = (a + b) / 2.0
        if func(midpoint) == 0:
            return midpoint
        elif func(a) * func(midpoint) < 0:
            b = midpoint
        else:
            a = midpoint
        iteration += 1
    
    return (a + b) / 2.0
