from scipy.stats import norm

mu=0
sigma=1

y1 = norm.cdf(1, mu, sigma) 
y2 = norm.cdf(-1, mu, sigma) 

print('P(-1≤Z≤1)=', y1-y2, '\n')


from scipy.stats import t

df=10
y1 = t.cdf(1, df)
y2 = t.cdf(-1, df)
print('df=', df)
print('P(-1≤X≤1)=', y1-y2, '\n')

df=30
y1 = t.cdf(1, df)
y2 = t.cdf(-1, df)
print('df=', df)
print('P(-1≤X≤1)=', y1-y2, '\n')

df=50
y1 = t.cdf(1, df)
y2 = t.cdf(-1, df)
print('df=', df)
print('P(-1≤X≤1)=', y1-y2, '\n')

df=100
y1 = t.cdf(1, df)
y2 = t.cdf(-1, df)
print('df=', df)
print('P(-1≤X≤1)=', y1-y2, '\n')
