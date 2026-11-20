from scipy.stats import binom

n=100
p=0.5
percent_point=0.9 

print('P(X≤k)=0.9, k=',binom.ppf(percent_point, n, p))
