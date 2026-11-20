import pandas as pd
obs_freq = [109, 95, 92, 105, 101, 98]
exp_freq = [100, 100, 100, 100, 100, 100]

from scipy.stats import chisquare
result = chisquare(obs_freq, f_exp=exp_freq)
print(result)
