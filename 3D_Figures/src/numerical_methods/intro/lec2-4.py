'''
exceptional handeling
'''

import numpy as np

# def square(n):
#     if n < 0:
#         raise ValueError("Cannot compute square root of negative number")
#     return np.sqrt(n)

try:
    def square(n):
        return np.sqrt(n)
except ValueError as ve:
    print(f'error {ve}')
    
num = float(input("Enter a number to find its square root: "))
print(f"The square root of {num} is {square(num)}")