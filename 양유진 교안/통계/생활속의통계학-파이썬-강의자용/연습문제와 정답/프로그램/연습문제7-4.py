import numpy as np
import scipy.stats as st
from matplotlib import pyplot as plt

n=1000
mean = np.zeros(n)
x = np.zeros(100)
sample = np.zeros(10)

for i in range(0, n):
    x = st.norm.rvs(50, 10, size=100)
    sample = np.random.choice(x, 10)
    mean[i]= sample.mean()

print(mean.mean())
print(mean.std())

plt.hist(mean, bins=20) 
plt.show()


    
