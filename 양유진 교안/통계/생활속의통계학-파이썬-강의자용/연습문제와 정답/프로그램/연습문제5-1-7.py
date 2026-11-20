import numpy as np
import scipy.stats as st
import matplotlib.pyplot as plt

x = np.zeros(10)
mean = np.zeros(100)

for i in range(0, 100):
     x = st.uniform.rvs(0, 1, size=10)
     mean[i]=np.mean(x)

plt.hist(mean, bins=10) #막대수 5
plt.title('uniform random number(sample=10)')
plt.show()
