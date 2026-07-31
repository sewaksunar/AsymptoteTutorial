from matplotlib import pyplot
import numpy, pandas

eqn = input("Enter function of x using Python syntax: ")

def f(x):
    try: 
        return eval(eqn)
        
    except (SyntaxError, TypeError, NameError):
        print("Invalid syntax!")

def df(f, x, h=1e-10):
    return (f(x + h)-f(x-h))/(2*h)

a = float(input("Enter the  initial guess:"))

if df(f, a) == 0:
    print("The derivative is zero at initial guess! Change initial guess!")
    exit
else:
    e, N= float(input("Enter tolerable error: ")), int(input("Enter maximum number of iterations allowed: "))

i, A, B = 1, [], []

while i <= N:
    A.append(a)
    b = a - f(a)/df(f, a)
    error = abs(b-a)

    B.append([i, a, b, f(a), df(f, a), error])

    if df(f, b) == 0:
        print("Division by zero! Change initial guess!")
        break
    else:
        if error < e:
            break
        else:
            a = b
            i +=1
# result
if i > N:
    print("Solution not found within maximum iterations!")
else:
    print(pandas.DataFrame(B, columns = ["i", 'a', 'b', 'f(a)', 'deri f(a)', 'Error']))
    print(f"Approximate root found in {i} iteration: {b}")

# visulization function
x = numpy.linspace(a- 5, a+5, 1000)
y = f(x)

pyplot.plot(x, y, label='f(x)', color='blue')
pyplot.axhline(0, color="red", ls="--")

# marker visual
A = numpy.array(A)
y = numpy.zeros_like(A)
for i, v in enumerate(A):
    pyplot.text(v, f(v), f'{i+1}')
pyplot.scatter(A, y, marker="x")

# tangent lines 
for i, a in enumerate(A):
    tangent = f(a) + df(f, a) * (x - a)
    pyplot.plot(x, tangent, '--', label=f'Tangent {i+1}')

    
pyplot.show()

