import pandas as pd
obs = pd.DataFrame({'남':[25, 36], '여': [35, 4]})
obs.index=['찬성', '반대']
from scipy.stats import chi2_contingency
print(obs)
result = chi2_contingency(obs, correction = False)
print(result)
