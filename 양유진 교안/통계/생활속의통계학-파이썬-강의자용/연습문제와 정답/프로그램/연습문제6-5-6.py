import pandas as pd
obs = pd.DataFrame({'남':[41, 6, 3], '여': [30, 15, 5]})
obs.index=['만족', '보통', '불만족']
from scipy.stats import chi2_contingency 
print(obs)
result = chi2_contingency(obs, correction = False)
print(result)
