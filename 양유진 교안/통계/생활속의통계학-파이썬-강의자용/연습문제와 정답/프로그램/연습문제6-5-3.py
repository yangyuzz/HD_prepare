import pandas as pd
obs = pd.DataFrame({'남':[68, 43, 25], '여': [45, 36, 15]})
obs.index=['인터넷', '어플', '통화&문자']
from scipy.stats import chi2_contingency
print(obs)
result = chi2_contingency(obs, correction = False)
print(result)
