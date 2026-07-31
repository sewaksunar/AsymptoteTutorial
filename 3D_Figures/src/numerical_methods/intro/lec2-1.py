'''
Docstring for lec2-1
matrix input using split function
'''
import numpy as np

n = int(input("Enter the row: "))
# m = float(input("Enter the column: "))
a =[]

for i in range(n):
    a.append(list(map(float, input(f"Enter row element {i}: ").split())))
a = np.array(a)

print(a)