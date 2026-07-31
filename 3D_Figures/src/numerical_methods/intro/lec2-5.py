
def fun(a, b, c):
    return a*b*c

a = [1, 2, 3]
b = [4, 5, 6]
c = [7, 8, 9, 4]

print(list(zip(a, b, c))) # it zip the elemets of corresponding index together

print(list(map(fun, a, b, c))) # it applies the function to the corresponding elements of the iterables

sum = list(map(lambda y: y[0] + y[1] + y[2], zip(a, b, c))) # it adds the corresponding elements of the iterables
print(sum)