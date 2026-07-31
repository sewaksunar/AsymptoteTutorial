import numpy as np

def f(x):
    return x**2 - 4*x - 9

def bisect(x, a, b, itr):
    x = (x+b)/2
    itr +=1

a, b = float(input("Enter a, b").split())