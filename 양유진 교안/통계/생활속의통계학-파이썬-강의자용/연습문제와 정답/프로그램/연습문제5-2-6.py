import scipy.stats as st
from scipy.stats import t


n1=10
n2=50
n3=100
mean=25
std=10

print('신뢰구간(95%, n=10) t.interval =')
print(st.t.interval(0.95, n1-1, loc=mean, scale=std))

print('신뢰구간(95%, n=50) t.interval =')
print(st.t.interval(0.95, n2-1, loc=mean, scale=std))

print('신뢰구간(95%, n=100) t.interval =')
print(st.t.interval(0.95, n3-1, loc=mean, scale=std))
