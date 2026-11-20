import scipy.stats as st
from scipy.stats import t

n=20
mean=170
std=15

print('신뢰구간(95%) t.interval =')
print(st.t.interval(0.95, n-1, loc=mean, scale=std))
print('신뢰구간(99%) t.interval =')
print(st.t.interval(0.99, n-1, loc=mean, scale=std))
