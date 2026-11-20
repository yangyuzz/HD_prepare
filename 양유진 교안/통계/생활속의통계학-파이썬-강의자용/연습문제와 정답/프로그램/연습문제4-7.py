import numpy as np

data=np.array([1, 2, 3, 4, 5, 6, 7, 8, 9])

z = (data - data.mean())/data.std()

print(z)

print('mean of z=', z.mean())
print('std of z=', z.std())
