import numpy as np

size=6
x = np.zeros(size)
sum = np.zeros(46)
total = 0
max = 0
index=0

for i in range(0, 100):
    x=np.random.randint(1, 46, size)
    x=np.random.choice(x, size, replace=False)
    for j in range(0, 6):
        sum[x[j]]=sum[x[j]]+1


for i in range(1, 46):
    print(i, ' =', sum[i]);
    if sum[i] >= max:
            max=sum[i]
            index=i     
    total = total + sum[i]


print('total=', total)
print('index =', index, 'max=', sum[index])

    
