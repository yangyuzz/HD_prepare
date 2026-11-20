import pandas as pd
import matplotlib.pyplot as plt
df = pd.DataFrame(pd.read_excel("..\데이터\초등학생 키와몸무게.xlsx"))

import scipy.stats as stats
# 피어슨 상관계수 검정
corr = stats.pearsonr(df.weight, df.height)
print(corr)

import seaborn as sns
sns.regplot(x=df.height, y=df.weight)
plt.show()

from statsmodels.formula.api import ols
res = ols('df.weight ~ df.height', data=df).fit()
print(res.summary())
