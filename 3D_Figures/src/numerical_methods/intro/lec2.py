'''
matrix using nested list comprehension
'''
import numpy as np

m1 = int(input("Enter the no of rows:"))
n1 = int(input("Enter the no of columns:"))

a = [[float(input(f"Enter the element a{i}{j}: ") ) for j in range(n1)] for i in range(m1)]

m2 = int(input("Enter the no of rows:"))
n2 = int(input("Enter the no of columns:"))

b = [[float(input(f"Enter the element b{i}{j}: ")) for j in range(n2)] for i in range(m2)]
a = np.array(a)
b = np.array(b)

c = np.dot(a, b)
print(c)