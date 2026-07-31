import numpy as np
from pandas import DataFrame

A = {"Name": ["Prit", "Suresh", "CR"],
     "Age": [25, 30, 35],  
     "Address": ["Dharan", "Karnali", "Hetauda"]}

B= DataFrame(A).to_string(index=False)
print(B)