import numpy as np
from scipy.stats import norm

mu=0
sigma=1

p1 = norm.cdf(1.5, mu, sigma) 
p2 = norm.cdf(0.5, mu, sigma) 
p3 = norm.cdf(-0.5, mu, sigma)
p4 = norm.cdf(-1.5, mu, sigma)

print('P(1.5≤Z)=', p1)
print('P(-0.5≤Z≤0.5)=', p2-p3)
print('P(Z≤-1.5)=', p4)
