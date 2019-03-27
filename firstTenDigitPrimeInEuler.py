import operator
import decimal
from functools import reduce


def isprime(a):
    if a < 2: return False
    if a == 2 or a == 3: return True  # manually test 2 and 3
    if a % 2 == 0 or a % 3 == 0: return False  # exclude multiples of 2 and 3
    maxDivisor = a ** 0.5
    d, i = 5, 2
    while d <= maxDivisor:
        if a % d == 0: return False
        d += i
        i = 6 - i  # this modifies 2 into 4 and viceversa
    return True


decimal.getcontext().prec = 150
e_from_decimal = decimal.Decimal(1).exp().to_eng_string()[2:]
print("2."+e_from_decimal)
for i in range(len(e_from_decimal)-10):
     x = int(reduce(operator.add,e_from_decimal[i:i+10]))
     if isprime(x):
         print(x)
         print(i)
         break
