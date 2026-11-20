import numpy as np
from scipy.stats import norm

mu=75
sigma=10

p1 = norm.cdf(90, mu, sigma) 
p2 = norm.cdf(80, mu, sigma) 
p3 = norm.cdf(70, mu, sigma)
p4 = norm.cdf(60, mu, sigma)

print('P(90≤X)=', p1)
print('P(70≤X≤80)=', p2-p3)
print('P(X≤60)=', p4)
