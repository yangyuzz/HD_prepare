import pandas as pd
obs = pd.DataFrame({'가짜약':[55, 45], '비타민C': [75, 25]})
obs.index=['감기걸리지 않음', '감기걸림']
from scipy.stats import chi2_contingency
print(obs)
result = chi2_contingency(obs, correction = False)
print(result)
