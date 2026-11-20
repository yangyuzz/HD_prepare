import scipy.stats as st
from scipy.stats import t

n=25
mean=35
std=5

print('신뢰구간 t.interval =')
print(st.t.interval(0.95, n-1, loc=mean, scale=std))
