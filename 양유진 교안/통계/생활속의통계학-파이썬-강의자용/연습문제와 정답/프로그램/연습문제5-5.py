from scipy.stats import norm
mu=0
sigma=1
percent_point=0.95

print('P(Z≤k)=0.95, k=',norm.ppf(percent_point, mu, sigma))



from scipy.stats import t
df=100
percent_point=0.95 
print('P(t≤k)=0.95, k=',t.ppf(percent_point, df))
