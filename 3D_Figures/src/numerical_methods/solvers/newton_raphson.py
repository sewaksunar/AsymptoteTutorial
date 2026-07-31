class NewtonRaphson:
    def __init__(self, func, dfunc, tol: float = 1e-6, max_iter: int = 50):
        self.func = func
        self.dfunc = dfunc
        self.tol = tol
        self.max_iter = max_iter
        self.history = []  # To store steps for plotting later

    def solve(self, x0: float):
        x = x0
        for i in range(self.max_iter):
            fx = self.func(x)
            dfx = self.dfunc(x)
            
            if abs(dfx) < 1e-12:
                raise ValueError("Derivative too small; Newton-Raphson fails.")

            x_new = x - fx / dfx
            self.history.append(x_new)

            if abs(x_new - x) < self.tol:
                return x_new
            
            x = x_new
            
        raise TimeoutError("Newton-Raphson did not converge within max iterations.")