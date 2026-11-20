import pandas as pd
import matplotlib.pyplot as plt
df = pd.DataFrame(pd.read_excel("..\데이터\강수량데이터.xlsx"))

import scipy.stats as stats
# 피어슨 상관계수 검정
corr = stats.pearsonr(df.temperature, df.rainfall)
print(corr)

import seaborn as sns
sns.regplot(x=df.temperature, y=df.rainfall)
plt.show()

from statsmodels.formula.api import ols
res = ols('df.rainfall ~ df.temperature', data=df).fit()
print(res.summary())
