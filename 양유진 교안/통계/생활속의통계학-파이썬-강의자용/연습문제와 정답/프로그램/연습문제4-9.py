import numpy as np

data=np.array([172, 168, 177, 175, 165, 170, 167, 172, 173, 170])
z = (data - data.mean())/data.std()
print(z)

print('mean of z=', z.mean())
print('std of z=', z.std())
