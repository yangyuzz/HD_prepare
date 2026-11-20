import pandas as pd
import matplotlib.pyplot as plt
df = pd.DataFrame(pd.read_excel("..\데이터\과수원수확량.xlsx"))

import scipy.stats as stats
# 피어슨 상관계수 검정
corr = stats.pearsonr(df.temperature, df.output)
print(corr)

import seaborn as sns
sns.regplot(x=df.temperature, y=df.output)
plt.show()

from statsmodels.formula.api import ols
res = ols('df.output ~ df.temperature', data=df).fit()
print(res.summary())
