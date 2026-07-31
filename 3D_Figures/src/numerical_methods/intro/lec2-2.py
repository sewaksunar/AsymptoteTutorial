
n = int(input('Enter the no of terms: '))

sum = 0
i =1

# for i in range(1, n+1):
#     sum +=i
while i <= n:
    sum +=i
    i +=1

print(f'Sum of first nth natural number is {sum}')