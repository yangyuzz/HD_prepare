import numpy as np

x = [1, 2, 3, 4, 5, 6]
dice = np.zeros(7)
sum =0

for i in range(0, 1000):
    index = np.random.choice(x)
    dice[index]=dice[index]+1

for i in range(1, 7):
    sum = sum + dice[i]
    print('눈금: ', i, '의 빈도 = ', dice[i])

print('합계 = ', sum)
print('\n')

sum=0
for i in range(1, 7):
    sum=sum+ dice[i]/1000
    print('눈금: ', i, '의 확률 = ', dice[i]/1000)

print('합계 = ', sum)


