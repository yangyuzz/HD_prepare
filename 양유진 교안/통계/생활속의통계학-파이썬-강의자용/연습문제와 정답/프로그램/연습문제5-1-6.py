import numpy as np
import matplotlib.pyplot as plt


loc = 70
scale = 15
x = np.zeros(5)

x = np.random.normal(loc, scale, size=1000)

plt.hist(x, bins=10) #막대수 5
plt.title('normal random number(1,000)')
plt.show()

