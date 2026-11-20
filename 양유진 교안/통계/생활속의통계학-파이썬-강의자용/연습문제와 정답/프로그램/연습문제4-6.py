import numpy as np
from matplotlib import pyplot as plt
from scipy.stats import norm

mu=175
scale=20

x = np.arange(mu-70, mu+70, 0.1)
y = norm.pdf(x, mu, scale) 

plt.bar(x, y)
plt.xlabel('X')
plt.ylabel('f(X)')
plt.title('normal distribution(mu=175, sigma=20)')
plt.show()
