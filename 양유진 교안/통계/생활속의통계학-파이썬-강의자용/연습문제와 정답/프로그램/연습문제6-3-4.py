import pandas as pd
from statsmodels.formula.api import ols
from statsmodels.stats.anova import anova_lm

# load data file
df = pd.read_excel("..\데이터\토마토 생산량.xlsx")
model = ols('output ~  C(fertilizer)+ C(states)', data=df).fit()
print(anova_lm(model))
print()

# Tukey's test
from statsmodels.stats.multicomp import pairwise_tukeyhsd
tukey = pairwise_tukeyhsd(endog=df['output'], groups=df['states'], alpha=0.05)
print(tukey)

tukey = pairwise_tukeyhsd(endog=df['output'], groups=df['fertilizer'], alpha=0.05)
print(tukey)
