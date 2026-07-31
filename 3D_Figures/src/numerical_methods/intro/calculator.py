import numpy as np

a, b = map(float, input('Enter two numbers a and b: ').split())

op = input('Enter the operation (+, -, *, /, **): ')

if op == '+':
    result = a + b
elif op == '-':
    result = a - b
elif op == '*':
    result = a * b
elif op == '/':
    if b != 0:
        result = a / b
    else:
        result = 'Error: Division by zero'
elif op == '**':
    result = a ** b
else:
    result = 'Error: Invalid operation'
print('Result:', result)