import numpy as np
from matplotlib import pyplot as plt
from scipy.stats import norm

mu=70
scale=15

x = np.arange(mu-50, mu+50, 0.1)
y = norm.pdf(x, mu, scale) 

plt.bar(x, y)
plt.xlabel('X')
plt.ylabel('f(X)')
plt.title('normal distribution(mu=70, sigma=15)')
plt.show()
