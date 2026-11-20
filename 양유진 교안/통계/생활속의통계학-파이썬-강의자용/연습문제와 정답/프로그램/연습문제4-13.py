from scipy.stats import norm

mu=0
sigma=1
percent_point=0.95
print('P(Z≤k)=0.95, k=',norm.ppf(percent_point, mu, sigma))

percent_point=0.975
print('P(Z≤k)=0.975, k=',norm.ppf(percent_point, mu, sigma))

percent_point=0.05
print('P(Z≤k)=0.05, k=',norm.ppf(percent_point, mu, sigma))

percent_point=0.01
print('P(Z≤k)=0.01, k=',norm.ppf(percent_point, mu, sigma))

percent_point=0.1
print('P(k≤Z)=0.9를 만족하는 k는 P(Z≤k)=0.1, k=',norm.ppf(percent_point, mu, sigma))



