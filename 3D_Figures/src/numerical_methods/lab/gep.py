import numpy as np

def gaussian_elimination_partial(aug):
    """
    Gaussian Elimination with Partial Pivoting.
    Input: augmented matrix [A|b] of shape (n, n+1)
    Output: solution vector x
    """
    n = aug.shape[0]

    # Forward elimination
    for i in range(n):
        # Partial pivoting (row swap)
        max_row = np.argmax(abs(aug[i:, i])) + i
        aug[[i, max_row]] = aug[[max_row, i]]
        
        # Eliminate below pivot
        for j in range(i+1, n):
            factor = aug[j, i] / aug[i, i]
            aug[j, i:] -= factor * aug[i, i:]
    
    # Back substitution
    x = np.zeros(n)
    for i in range(n-1, -1, -1):
        x[i] = (aug[i, -1] - np.dot(aug[i, i+1:n], x[i+1:n])) / aug[i, i]
    
    return x


def gaussian_elimination_complete(aug):
    """
    Gaussian Elimination with Complete Pivoting.
    Input: augmented matrix [A|b] of shape (n, n+1)
    Output: solution vector x
    """
    n = aug.shape[0]
    col_swaps = list(range(n))  # Track column swaps

    # Forward elimination
    for i in range(n):
        # Find pivot in submatrix
        submatrix = abs(aug[i:, i:n])
        max_idx = np.unravel_index(np.argmax(submatrix), submatrix.shape)
        pivot_row, pivot_col = max_idx[0] + i, max_idx[1] + i

        # Swap rows
        aug[[i, pivot_row]] = aug[[pivot_row, i]]
        # Swap columns (excluding last column b)
        aug[:, [i, pivot_col]] = aug[:, [pivot_col, i]]
        col_swaps[i], col_swaps[pivot_col] = col_swaps[pivot_col], col_swaps[i]

        # Eliminate below pivot
        for j in range(i+1, n):
            factor = aug[j, i] / aug[i, i]
            aug[j, i:] -= factor * aug[i, i:]

    # Back substitution
    x = np.zeros(n)
    for i in range(n-1, -1, -1):
        x[i] = (aug[i, -1] - np.dot(aug[i, i+1:n], x[i+1:n])) / aug[i, i]

    # Reorder solution according to column swaps
    x_final = np.zeros(n)
    for i in range(n):
        x_final[col_swaps[i]] = x[i]

    return x_final

aug = np.array([
    [10, -7, 3, 5, 6],
    [ -6, 8, -1, -4, 5],
    [3, 1, 4, 11, 2],
    [5, -9, -2, 4, 7]
], dtype=float)

x_partial = gaussian_elimination_partial(aug.copy())
x_complete = gaussian_elimination_complete(aug.copy())

print("Solution with Partial Pivoting:", x_partial)
print("Solution with Complete Pivoting:", x_complete)
