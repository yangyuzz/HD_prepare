import numpy as np
from matplotlib import pyplot as plt

n=1
p=0.5
rand_x = np.zeros(1000)

rand_x = np.random.binomial(n, p, size=1000)
sum_1 = rand_x.sum()
sum_0 = 1000-sum_1

print('# of case X=0 : ', sum_0)
print('# of case X=1 : ', sum_1)


x = ['0', '1']
y = [sum_0, sum_1]

plt.bar(x, y)
plt.show()

