import numpy as np
from matplotlib import pyplot as plt

n=1
p=0.5
x = np.zeros(1000)
sum = np.zeros(1000)

for i in range(0, 1000):
    x = np.random.binomial(n, p, size=1000)
    sum[i]= x.sum()

plt.hist(sum, bins=20) 
plt.show()
